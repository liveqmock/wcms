package com.kiy.wcms.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
/**
 * 日期字符串与long之间的转换工具累
 * @author wuwenlong
 * @date 2014年10月01日
 */
public class SimpleDateUtil {
	// 短日期格式
	 public static String DATE_FORMAT = "yyyy-MM-dd";
	 
	 // 长日期格式
	 public static String TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";

	 

	 /**
	  * 将日期格式的字符串转换为长整型
	  * 
	  * @param date
	  * @param format
	  * @return
	  */
	 public static long convert2long(String date, String format) {
	  try {
	   if (!"".equals(date)) {
	    if (format==null||"".equals(format))
	     format = SimpleDateUtil.TIME_FORMAT;

	    SimpleDateFormat sf = new SimpleDateFormat(format);
	    return sf.parse(date).getTime();
	   }
	  } catch (ParseException e) {
	   e.printStackTrace();
	  }
	  return 0l;
	 }

	 

	 /**
	  * 将长整型数字转换为日期格式的字符串
	  * 
	  * @param time
	  * @param format
	  * @return
	  */
	 public static String convert2String(long time, String format) {
	  if (time > 0l) {
	   if (format==null||"".equals(format))
	    format = SimpleDateUtil.TIME_FORMAT;

	   SimpleDateFormat sf = new SimpleDateFormat(format);
	   Date date = new Date(time);

	   return sf.format(date);
	  }
	  return "";
	 }

	 

	 /**
	  * 获取当前系统的日期
	  * 
	  * @return
	  */
	 public static long curTimeMillis() {
	  return System.currentTimeMillis();
	 }

	 

	 /**
	  * 示例函数
	  * 
	  * @param args
	  */
	 public static void main(String[] args) {
	  System.out.println(SimpleDateUtil.convert2long("2000-01-01 01:01:01",
	    SimpleDateUtil.DATE_FORMAT));

	  System.out.println(SimpleDateUtil.convert2String(SimpleDateUtil
	    .curTimeMillis(), SimpleDateUtil.TIME_FORMAT));
	  
	 }
}
