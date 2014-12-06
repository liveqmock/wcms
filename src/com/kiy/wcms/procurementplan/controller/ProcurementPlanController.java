package com.kiy.wcms.procurementplan.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;


import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.kiy.wcms.Global;
import com.kiy.wcms.procurementplan.service.ProcurementPlanService;
import com.kiy.wcms.procurementplan.entity.ProcurementDetail;
import com.kiy.wcms.procurementplan.entity.ProcurementDetailParam;
import com.kiy.wcms.procurementplan.entity.ProcurementPlan;
import com.kiy.wcms.procurementplan.entity.ProcurementPlanParam;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/procurementPlan/")
public class ProcurementPlanController {
	@Autowired
	private ProcurementPlanService procurementPlanService;
	@Autowired
	private UserService userService;
	
	/**
	 * 跳转到生成计划录入页面
	 * @param request
	 * @param pageType
	 * @return
	 */
	@RequestMapping("procurementInput")
	public String procurementInput(HttpServletRequest request,String pageType, Model model){
		if("list".equals(pageType)){
			return "/app/procurementPlan/procurement_plan_entering_list";
		}else{
			SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
			//是否为采购部领导
			boolean isCGBLD = userService.isHasRole(user, "CGBLD");
			//是否为财务部领导
			boolean isCWBLD = userService.isHasRole(user, "CWBLD");
			
			String seeStatus = "";
			if(isCGBLD){
				seeStatus = "10";
			}else if(isCWBLD){
				seeStatus = "20";
			}
			model.addAttribute("seeStatus", seeStatus);
			return "/app/procurementPlan/procurement_plan_approval_list";
		}
	}
	
	/**
	 * 获取生成计划列表
	 * @param page
	 * @param rows
	 * @param procurementPlanParam
	 * @param response
	 */
	@RequestMapping("getProcurementPlanList")
	public void getProcurementPlanList(Integer page, Integer rows, 
			ProcurementPlanParam procurementPlanParam, HttpServletResponse response){
		if(page==null){
			page = 1;
		}
		if(rows==null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		procurementPlanParam.setBegin(begin);
		procurementPlanParam.setRows(rows);
		JSONObject json = procurementPlanService.getProcurementPlanList(procurementPlanParam);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 保存采购计划
	 * @param procurementPlan
	 * @param response
	 * @param request
	 */
	@RequestMapping("saveProcurementPlan")
	public void saveProcurementPlan(
			ProcurementPlan procurementPlan, HttpServletResponse response, HttpServletRequest request) {
		// TODO Auto-generated method stub
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		procurementPlan.setCreateUser(user);
		procurementPlanService.saveProcurementPlan(procurementPlan);
		JSONObject json = new JSONObject();
		json.put("flag", true);
		json.put("data", JSONObject.fromObject(procurementPlan));
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 删除采购计划
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteProcurementPlan")
	public void deleteProcurementPlan(String id, HttpServletResponse response){
		boolean flag = procurementPlanService.deleteProcurementPlan(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 获取采购计划明细信息
	 * @param planId
	 * @param response
	 */
	@RequestMapping("getProcurementDetailList")
	public void getProcurementDetailList(String planId, HttpServletResponse response){
		JSONArray array = procurementPlanService.getProcurementDetailList(planId);
		AjaxUtil.outputJsonArray(response, array);
	}
	/**
	 * 保存采购计划明细信息
	 * @param procurementDetail
	 * @param response
	 */
	@RequestMapping("saveProcurementDetail")
	public void saveProcurementDetail(ProcurementDetail procurementDetail, HttpServletResponse response){
		boolean flag = procurementPlanService.saveProcurementDetail(procurementDetail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 编辑采购计划明细信息
	 * @param procurementDetail
	 * @param response
	 */
	@RequestMapping("updateProcurementDetail")
	public void updateProcurementDetail(ProcurementDetail procurementDetail, HttpServletResponse response){
		boolean flag = procurementPlanService.updateProcurementDetail(procurementDetail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 删除采购计划明细信息
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteProcurementDetail")
	public void deleteProcurementDetail(String id, HttpServletResponse response){
		boolean flag = procurementPlanService.deleteProcurementDetail(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 更新采购计划
	 * @param procurementPlan
	 * @param response
	 */
	@RequestMapping("updateProcurementPlan")
	public void updateProcurementPlan(ProcurementPlan procurementPlan, HttpServletResponse response){
		boolean flag = procurementPlanService.updateProcurementPlan(procurementPlan);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
//	/**
//	 * 获取物品库信息
//	 * @param response
//	 */
//	@RequestMapping("addProcurementDetailList")
//	public void addProcurementDetailList(HttpServletResponse response){
//		JSONArray array = procurementPlanService.addProcurementDetailList();
//		AjaxUtil.outputJsonArray(response, array);
//	}
	/**
	 * 上传采购计划附件
	 * @param planId
	 * @param file
	 * @param request
	 * @param response
	 */
	@RequestMapping("addAtta")
	public void addAtta(String planId, @RequestParam MultipartFile file, 
			HttpServletRequest request, HttpServletResponse response){
		String path = request.getSession().getServletContext().getRealPath("upload");
		path += File.separator + "procurementPlan" + File.separator + new SimpleDateFormat("yyyy").format(new Date()) + File.separator + planId;
		String filename = file.getOriginalFilename();
		File targetFile = new File(path, filename);
		
		int count = 1;
		while(targetFile.exists()){
			targetFile = new File(path + File.separator + "(" + count + ")" + filename);
			count++;
		}
		
		if(!targetFile.exists()){
			targetFile.mkdirs();
		}
		
		try {
			file.transferTo(targetFile);
			boolean flag = procurementPlanService.saveProcurementPlanAtta(planId, targetFile.getPath(), targetFile.getName());
			JSONObject json = new JSONObject();
			json.put("flag", flag);
			AjaxUtil.outputJson(response, json);
		} catch (IllegalStateException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	/**
	 * 获取附件列表
	 * @param planId
	 * @param response
	 */
	@RequestMapping("getProcurementPlanAttaList")
	public void getProcurementPlanAttaList(String planId, HttpServletResponse response){
		JSONArray array = procurementPlanService.getProcurementPlanAttaList(planId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 删除附件
	 * @param attaId
	 * @param response
	 */
	@RequestMapping("deleteProcurementPlanAtta")
	public void deleteProcurementPlanAtta(String attaId, HttpServletResponse response){
		boolean flag = procurementPlanService.deleteProcurementPlanAtta(attaId);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 下载附件
	 * @param attaId
	 * @param response
	 */
	@RequestMapping("downloadProcurementPlanAtta")
	public void downloadProcurementPlanAtta(String attaId, HttpServletResponse response){
		OutputStream out = null;
        
		String attaPath = procurementPlanService.getAttaPath(attaId);
		
		try {
			File file = new File(attaPath);
			response.reset();  
	        response.setHeader("Content-Disposition", "attachment; filename="+ URLEncoder.encode(file.getName(), "UTF-8"));  
	        response.setContentType("application/octet-stream; charset=utf-8");
	        out = response.getOutputStream();
	        out.write(FileUtils.readFileToByteArray(file));
	        
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally{
			if(out != null){
				try {
					out.flush();
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param seeStatus
	 * @param response
	 * @param request
	 */
	@RequestMapping("submitAudit")
	public void submitAudit(String id, String option, String seeStatus, String comment,
			HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		int status = 0;
		if("0".equals(option)){
			status = -5555;
		}else{
			status = 20;
			if("20".equals(seeStatus)){
				status = 30;
			}
		}
		boolean flag = procurementPlanService.submitAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 通过条件查询获取采购计划列表信息
	 * @param page
	 * @param rows
	 * @param procurementDetailParam
	 * @param response
	 */
	@RequestMapping("getPlanListByCondition")
	public void getPlanListByCondition(Integer page, Integer rows, 
			ProcurementDetailParam procurementDetailParam, HttpServletResponse response){
		if(page==null){
			page = 1;
		}
		if(rows==null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		procurementDetailParam.setBegin(begin);
		procurementDetailParam.setRows(rows);
		JSONObject json = procurementPlanService.getPlanListByCondition(procurementDetailParam);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交采购计划
	 */
	@RequestMapping("submitPlan")
	public void submitPlan(String id, HttpServletResponse response){
		boolean flag = procurementPlanService.submitPlan(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	@RequestMapping("getAuditPlanList")
	public void getAuditPlanList(Integer page, Integer rows, Integer auditStatus,
			ProcurementPlanParam procurementPlanParam, Integer seeStatus, HttpServletResponse response){
		if(page==null){
			page = 1;
		}
		if(rows==null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		procurementPlanParam.setBegin(begin);
		procurementPlanParam.setRows(rows);
		if(auditStatus == null){
			auditStatus = 0;
		}
		procurementPlanParam.setAuditStatus(auditStatus);
		JSONObject json = procurementPlanService.getAuditPlanList(procurementPlanParam);
		AjaxUtil.outputJson(response, json);
	}
}
