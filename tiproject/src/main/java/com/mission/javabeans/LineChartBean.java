package com.mission.javabeans;

import org.jfree.chart.*;
import org.jfree.data.category.*;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.xy.*;
import org.jfree.data.*;
import org.jfree.chart.renderer.category.*;
import org.jfree.chart.plot.*;
import java.awt.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class LineChartBean {

	public static void main(String arg[]){
		LineChartBean lcb = new LineChartBean();
		JFreeChart chart = lcb.getLineChart();
		ChartFrame frame=new ChartFrame("Line Chart",chart);
		frame.setSize(400,350);  
		frame.setVisible(true);
	}

	public JFreeChart getLineChart() {
		final DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		try {
			String driver = "oracle.jdbc.driver.OracleDriver";
			String url = "jdbc:oracle:thin:@192.168.5.12:1521:XE";
			String user = "testuser";
			String pass = "testuser";
			Connection con = null;
			Class.forName(driver);
			con = DriverManager.getConnection(url, user, pass);
			System.out.println("Link Success");
			String sql = "SELECT YIELD, PROCESS_NO FROM DASHBOARD WHERE PROCESS_NO > (SELECT (MAX(PROCESS_NO)-5) FROM DASHBOARD) ORDER BY PROCESS_NO"; 
			PreparedStatement st = con.prepareStatement(sql); 
			ResultSet rs = st.executeQuery(); 
			while (rs.next()) {
				System.out.println("Process : " + rs.getString(2));
				System.out.println("Yield : " + rs.getInt(1));
				
				dataset.addValue(rs.getInt(1), "Yield", rs.getString(2) + " round"); 
			}
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
			ex.printStackTrace();
		}
		
		JFreeChart chart = ChartFactory.createLineChart	(
			"Latest Yields (%)","", "", dataset, 
			PlotOrientation.VERTICAL, false,true,false);
		
		chart.setBackgroundPaint(new Color(81, 95, 109));
		chart.getTitle().setPaint(Color.white);
		//chart.getTitle().setFont(new Font("굴림", Font.BOLD, 15));
		
		CategoryPlot p = chart.getCategoryPlot();
		p.setBackgroundPaint(new Color(81, 95, 109));
		p.setOutlinePaint(new Color(81, 95, 109));
		p.setForegroundAlpha(0.7f);
		p.getDomainAxis().setLabelPaint(Color.white);
		p.getDomainAxis().setTickLabelPaint(Color.white);
		//p.getDomainAxis().setTickLabelFont(new Font("굴림", Font.PLAIN, 12));
		p.getRangeAxis().setLabelPaint(Color.white);
		p.getRangeAxis().setTickLabelPaint(Color.white);
        p.getRangeAxis().setLowerBound(60);
        
		return chart;
	}
}