package com.kiy.wcms.sys.controller;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/user/")
public class UserController {
	@Autowired
	private UserService userService;
	
	/**
	 * 根据角色获取用户
	 * @param roleCode
	 * @param response
	 */
	@RequestMapping("getUsersByRole")
	public void getUsersByRole(String roleCode, HttpServletResponse response){
		JSONArray array = userService.getUsersByRole(roleCode);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 获取所有用户
	 * @param response
	 */
	@RequestMapping("getAllUsers")
	public void getAllUsers(HttpServletResponse response){
		JSONArray array = userService.getAllUser();
		AjaxUtil.outputJsonArray(response, array);
	}
}
