package com.kiy.wcms.sys.controller;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kiy.wcms.Global;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/login/")
public class LoginController {
	@Autowired
	private UserService userService;
	
	/**
	 * 登陆
	 * @param username
	 * @param password
	 * @param response
	 * @throws IOException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping("login")
	public void login(String username, String password, HttpServletResponse response,
			HttpServletRequest request) throws IOException, NoSuchAlgorithmException{
		boolean flag = false;
		SysUser user = userService.login(username, password);
		if(user != null){
			request.getSession().setAttribute(Global.LOGIN_USER, user);
			flag = true;
		}
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 登出
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("logout")
	public String logout(Model model, HttpServletRequest request){
		request.getSession().removeAttribute(Global.LOGIN_USER);
		return "/index";
	}
	
	/**
	 * 修改密码
	 * @throws IOException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping("modifypwd")
	public void modifypwd(String newpass, HttpServletRequest request, HttpServletResponse response) throws IOException, NoSuchAlgorithmException{
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		JSONObject json = new JSONObject();
		boolean flag = userService.modifyPwd(user, newpass);
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
}
