package com.kiy.wcms.util;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public class AjaxUtil {
	/**
	 * 输出json对象
	 * @param response servlet接口
	 * @param json  json对象
	 * @throws IOException
	 */
	public static void outputJson(HttpServletResponse response, JSONObject json) {
		response.setContentType("text/html;charset=utf8");
		try {
			PrintWriter out = response.getWriter();
			out.println(json);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 输出json数组
	 * @param response  servlet接口
	 * @param array     要输出的json数组对象
	 * @throws IOException
	 */
	public static void outputJsonArray(HttpServletResponse response, JSONArray array){
		response.setContentType("text/html;charset=utf8");
		try {
			PrintWriter out = response.getWriter();
			out.println(array);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
