package com.mission.javabeans;

import java.awt.Color;
import java.awt.Font;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.jfree.chart.*;
import org.jfree.data.category.*;
import org.jfree.data.general.DefaultPieDataset;
import org.jfree.data.general.PieDataset;
import org.jfree.chart.plot.*;

public class PieChartBean {

	public static void main(String arg[]){
		PieChartBean pcb = new PieChartBean();
		JFreeChart chart = pcb.getPieChart();
		ChartFrame frame1=new ChartFrame("Pie Chart",chart);
		frame1.setSize(800,450);  
		frame1.setVisible(true);
	}

	public JFreeChart getPieChart() {
	    DefaultPieDataset dataset = new DefaultPieDataset();
		try {
			String driver = "oracle.jdbc.driver.OracleDriver";
			String url = "jdbc:oracle:thin:@192.168.5.12:1521:XE";
			String user = "testuser";
			String pass = "testuser";
			Connection con = null;
			Class.forName(driver);
			con = DriverManager.getConnection(url, user, pass);
			System.out.println("Link Success");
			String sql = "select YIELD,100-YIELD from DASHBOARD where PROCESS_NO=(select max(PROCESS_NO) from DASHBOARD)"; 
			PreparedStatement st = con.prepareStatement(sql); 
			ResultSet rs = st.executeQuery();
			
			String col1 = "Goods";
			String col2 = "Defects";
			while (rs.next()) {
				dataset.setValue(col2 + ": " + rs.getInt(2) + "%", rs.getInt(2)); 
				dataset.setValue(col1 + ": " + rs.getInt(1) + "%", rs.getInt(1));
			}
			
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
			ex.printStackTrace();
		}
        
		JFreeChart chart = ChartFactory.createPieChart("Yield For Last Session", dataset, false,true,false);
		chart.getTitle().setPaint(Color.white);
		//chart.getTitle().setFont(new Font("굴림", Font.BOLD, 15));
		chart.setBackgroundPaint(new Color(81, 95, 109));
		
		PiePlot p = (PiePlot)chart.getPlot();
		p.setForegroundAlpha(0.7f);
		p.setSectionPaint(0, new Color(250, 61, 61));
		p.setSectionPaint(1, new Color(52, 152, 219));
		p.setBackgroundPaint(new Color(81, 95, 109));
		p.setOutlinePaint(new Color(81, 95, 109));
		
		return chart;
	}
}
