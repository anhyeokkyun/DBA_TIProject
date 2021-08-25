package com.mission.javabeans;

import org.jfree.chart.*;
import org.jfree.chart.axis.ValueAxis;
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

public class BarChartBean {

	public static void main(String arg[]){
		BarChartBean bcb = new BarChartBean();
		JFreeChart chart = bcb.getBarChart();
		ChartFrame frame1=new ChartFrame("Bar Chart",chart);
		frame1.setSize(400,350);  
		frame1.setVisible(true);
	}

	public JFreeChart getBarChart() {
		final DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		try {
			String driver = "oracle.jdbc.driver.OracleDriver";
			String url = "jdbc:oracle:thin:@192.168.5.12:1521:XE";
			String user = "testuser";
			String pass = "testuser";
			Connection con = null;
			Class.forName(driver);
			con = DriverManager.getConnection(url, user, pass);
			System.out.println("연결성공");
			
			String sqlD3 = "select to_char(sysdate-3,'yymmdd'), avg(yield) from dashboard where SUBSTR(end_time,0,10) in (select to_char(sysdate-3,'yyyy:mm:dd') from dual)"; 
			PreparedStatement stD3 = con.prepareStatement(sqlD3); 
			ResultSet rsD3 = stD3.executeQuery(); 
			
			String sqlD2 = "select to_char(sysdate-2,'yymmdd'), avg(yield) from dashboard where SUBSTR(end_time,0,10) in (select to_char(sysdate-2,'yyyy:mm:dd') from dual)"; 
			PreparedStatement stD2 = con.prepareStatement(sqlD2); 
			ResultSet rsD2 = stD2.executeQuery(); 
			
			String sqlD1 = "select to_char(sysdate-1,'yymmdd'), avg(yield) from dashboard where SUBSTR(end_time,0,10) in (select to_char(sysdate-1,'yyyy:mm:dd') from dual)"; 
			PreparedStatement stD1 = con.prepareStatement(sqlD1); 
			ResultSet rsD1 = stD1.executeQuery(); 
			
			String sqlD0 = "select to_char(sysdate,'yymmdd'), avg(yield) from dashboard where SUBSTR(end_time,0,10) in (select to_char(sysdate,'yyyy:mm:dd') from dual)"; 
			PreparedStatement stD0 = con.prepareStatement(sqlD0); 
			ResultSet rsD0 = stD0.executeQuery(); 
			
			while (rsD3.next()) {
				dataset.addValue(rsD3.getInt(2),rsD3.getString(1), rsD3.getString(1)); 
			}
			
			while (rsD2.next()) {
				dataset.addValue(rsD2.getInt(2),rsD2.getString(1), rsD2.getString(1)); 
			}
			
			while (rsD1.next()) {
				dataset.addValue(rsD1.getInt(2),rsD1.getString(1), rsD1.getString(1)); 
			}
			
			while (rsD0.next()) {
				dataset.addValue(rsD0.getInt(2),rsD0.getString(1), rsD0.getString(1)); 
			}
			
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
			ex.printStackTrace();
		}
		
		JFreeChart chart = ChartFactory.createBarChart (
			"Daily Yield (%)","", "", dataset, 
			PlotOrientation.VERTICAL, false,true,true);
		
		chart.setBackgroundPaint(new Color(81, 95, 109));
		chart.getTitle().setPaint(Color.white); 
		//chart.getTitle().setFont(new Font("굴림", Font.BOLD, 15));
		
		CategoryPlot p = chart.getCategoryPlot();
		p.setBackgroundPaint(new Color(81, 95, 109));
		p.setOutlinePaint(new Color(81, 95, 109));
		p.setForegroundAlpha(0.7f);
		p.getDomainAxis().setLabelPaint(Color.white);
		p.getDomainAxis().setTickLabelPaint(Color.white);
		p.getRangeAxis().setLabelPaint(Color.white);
		p.getRangeAxis().setTickLabelPaint(Color.white);
        p.getRangeAxis().setLowerBound(60);

		//ValueAxis range = p.getRangeAxis();
		//range.setLabelAngle(90*(Math.PI / 180.0));
		
		return chart;
	}
}