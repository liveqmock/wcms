package com.kiy.wcms.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 签名工具类
 * @author Kiy Peng
 *
 */
public class SecurityUtil {
	
	/**
	 * 验证签名是否正确
	 * @param params
	 * @param sign
	 * @return 
	 */
	public static boolean checkSign(Map<String, String> params, String sign){
		boolean flag = false;
		if(sign!=null && !sign.trim().equals("") && !params.isEmpty()){
			flag = sign.equals(getSign(params));
		}
		return flag;
	}
	
	/**
	 * 验证公共密码是否正确
	 * @param commonPassword  客户端提交的密码
	 * @param salt    用户密码混淆码
	 * @param password   数据库中的用户密码密文
	 * @return
	 * @throws Exception 
	 */
	public static boolean checkCommonPassword(String commonPassword, String salt, String password){
		//连接salt与用户密码 密文
		String str = salt + password;
		//自然排序 组成新字符串
		char[] strArr = str.toCharArray();
		Arrays.sort(strArr);
		str = String.valueOf(strArr);
		
		//MD5加密
		try {
			str = MD5(str);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return false;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return false;
		}
		return str.equals(commonPassword);
	}
	
	/**
	 * 获取公共密码
	 * @param salt
	 * @param password
	 * @return
	 * @throws NoSuchAlgorithmException 
	 * @throws UnsupportedEncodingException 
	 */
	public static String getCommonPassword(String salt, String password) throws UnsupportedEncodingException, NoSuchAlgorithmException{
		//获取密码密文
		String str = MD5(salt + password);
		//salt连接密码密文
		str = salt + str;
		
		//自然排序 组成新字符串
		char[] strArr = str.toCharArray();
		Arrays.sort(strArr);
		str = String.valueOf(strArr);
		
		return MD5(str);
	}
	
	/**
	 * 获取签名
	 * @param params
	 * @return
	 */
	private static String getSign(Map<String, String> params){
		try {
			if (params == null) {
				return "";
			}
			List<String> list = new ArrayList<String>();
			Set<String> keySet = params.keySet();
			for (String string : keySet) {
				list.add(string);
			}
			Collections.sort(list);
			String string = new String();
			for (int i = 0; i < list.size(); i++) {
				string += (list.get(i) + "=" + params.get(list.get(i)) + "&");
			}
			if (string.length() > 0 && '&' == string.charAt(string.length() - 1)) {
				string = string.substring(0, string.length() - 1);
			}
			string = MD5(string);
			return string;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * 对目标字符串进行MD5加密
	 * @param source
	 * @return
	 * @throws UnsupportedEncodingException 
	 * @throws NoSuchAlgorithmException 
	 * @throws Exception
	 */
	public static String MD5(String source) throws UnsupportedEncodingException, NoSuchAlgorithmException {
		String resultHash = null;
		MessageDigest md5 = MessageDigest.getInstance("MD5");
		byte[] result = new byte[md5.getDigestLength()];
		md5.reset();
		md5.update(source.getBytes("UTF-8"));
		result = md5.digest();

		StringBuffer buf = new StringBuffer(result.length * 2);

		for (int i = 0; i < result.length; i++) {
			int intVal = result[i] & 0xff;
			if (intVal < 0x10) {
				buf.append("0");
			}
			buf.append(Integer.toHexString(intVal));
		}

		resultHash = buf.toString();

		return resultHash.toString();
		
	}
}
