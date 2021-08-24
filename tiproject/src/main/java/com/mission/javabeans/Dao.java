package com.mission.javabeans;

import java.sql.*;
import java.io.*;


public class Dao {
   public int Delete(String[] chbox) {
      String sql = "delete from PROD where PROD_NO=?";
      Connection conn = null;
      PreparedStatement pstmt = null;
      int[] count = null;
      String url = "jdbc:oracle:thin:@192.168.5.12:1521:XE";
      String uid = "admin";
      String pass = "admin";
//      Class.forName("oracle.jdbc.driver.OracleDriver");
//      
      try {
         conn = DriverManager.getConnection(url, uid, pass);
      } catch (SQLException e1) {
         // TODO Auto-generated catch block
         e1.printStackTrace();
      }

      int res = 0;

      try {
         pstmt = conn.prepareStatement(sql);
         
         for (int i = 0; i < chbox.length; i++) {
            pstmt.setString(1, chbox[i]);
            pstmt.addBatch();
         }

         count = pstmt.executeBatch();

         for (int i = 0; i < count.length; i++) {
            if (count[i] == -2) {

               res++;

            }
         }

         if (chbox.length == res) {
            conn.commit();

         } else {
            conn.rollback();
         }

      } catch (Exception e) {
         e.printStackTrace();
      } finally {
         try {
            pstmt.close();
            conn.close();
         } catch (Exception e) {
            e.printStackTrace();
         }
      }
      return res;
   }
}
