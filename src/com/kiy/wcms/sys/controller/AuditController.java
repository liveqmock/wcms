package com.kiy.wcms.sys.controller;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/audit/")
public class AuditController {
	@Autowired
	private AuditService auditService;
	
	/**
	 * 获取审批记录列表
	 * @param id
	 * @param type
	 * @param response
	 */
	@RequestMapping("getAuditList")
	public void getAuditList(String id, String type, HttpServletResponse response){
		JSONArray array = auditService.getAuditList(id, type);
		AjaxUtil.outputJsonArray(response, array);
	}
}
