package com.kiy.wcms.producplan.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kiy.wcms.Global;
import com.kiy.wcms.order.entity.Order;
import com.kiy.wcms.order.entity.OrderDetail;
import com.kiy.wcms.producplan.entity.ProducPlanParam;
import com.kiy.wcms.producplan.service.ProducPlanService;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;
import com.kiy.wcms.util.ExportExcel;

@Controller
@RequestMapping("/producPlan/")
public class ProducPlanController {
	@Autowired
	private ProducPlanService producPlanService;
	@Autowired
	private UserService userService;
	
	/**
	 * 跳转到生成计划录入页面
	 * @return
	 */
	@RequestMapping("inputManager")
	public String inputManager(){
		return "/app/productionPlan/production_plan_entering_list";
	}
	
	/**
	 * 获取生成计划列表
	 * @param page
	 * @param rows
	 * @param producPlanParam
	 * @param response
	 */
	@RequestMapping("getProducPlanList")
	public void getProducPlanList(Integer page, Integer rows, 
			ProducPlanParam producPlanParam, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page-1)*rows;
		producPlanParam.setPage(page);
		producPlanParam.setRows(rows);
		producPlanParam.setBegin(begin);
		
		JSONObject json = producPlanService.getProducPlanList(producPlanParam);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存技术参数
	 * @param orderDetail
	 * @param response
	 */
	@RequestMapping("saveTechParam")
	public void saveTechParam(OrderDetail orderDetail, HttpServletResponse response){
		boolean flag = producPlanService.saveTechParam(orderDetail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交生成计划
	 * @param id
	 * @param response
	 */
	@RequestMapping("submitProducPlan")
	public void submitProducPlan(String id, HttpServletResponse response){
		boolean flag = producPlanService.submitProducPlan(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到生成计划审批页面
	 * @param response
	 */
	@RequestMapping("auditManager")
	public String auditManager(HttpServletRequest request, Model model){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		//是否为销售部领导
		boolean isXSBLD = userService.isHasRole(user, "XSBLD");
		//是否为技术部领导
		boolean isJSBLD = userService.isHasRole(user, "JSBLD");
		//是否为采购部领导
		boolean isCGBLD = userService.isHasRole(user, "CGBLD");
		
		String seeStatus = "";
		if(isXSBLD){
			seeStatus = "10";
		}else if(isJSBLD){
			seeStatus = "20";
		}else if(isCGBLD){
			seeStatus = "25";
		}
		model.addAttribute("seeStatus", seeStatus);
		return "/app/productionPlan/production_plan_approval_list";
	}
	
	/**
	 * 获取生产计划审批列表
	 * @param seeStatus
	 * @param response
	 */
	@RequestMapping("getAuditPlanList")
	public void getAuditPlanList(
			Integer page, Integer rows,
			ProducPlanParam param, Integer auditStatus, 
			String seeStatus, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		param.setPage(begin);
		param.setRows(rows);
		
		if(auditStatus == null){
			auditStatus = 0;
		}
		param.setSeeStatus(seeStatus);
		param.setAuditStatus(auditStatus);
		JSONObject json = producPlanService.getAuditList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交审批
	 * @param id
	 * @param options
	 * @param seeStatus
	 * @param request
	 * @param response
	 */
	@RequestMapping("submitAudit")
	public void submitAudit(String id, String option, String seeStatus, String comment,
			HttpServletRequest request, HttpServletResponse response){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		int status = 0;
		if("0".equals(option)){
			status = -5555;
		}else{
			status = 20;
			if("20".equals(seeStatus)){
				status = 25;
			}else if("25".equals(seeStatus)){
				status = 30;
			}
		}
		
		boolean flag = producPlanService.submitAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 导出项目计划单
	 * @param id
	 * @param response
	 */
	@RequestMapping("printProductPlan")
	public void printProductPlan(String id, HttpServletResponse response, HttpServletRequest request){
		ExportExcel export = new ExportExcel();
		Map<String,Object> targetMap = new HashMap<String, Object>();
		//将数据加入targetMap中
		//order基础数据
		Order order = producPlanService.getOrderByProId(id);
		targetMap.put("order", order);
		//showList产品清单
		List<OrderDetail> showList = producPlanService.getOrderDetailListByProId(id);
		targetMap.put("showlist", showList);
		
		String path = request.getSession().getServletContext()
				.getRealPath("/WEB-INF/template/");
		export.exportToStream(path + "/project_plan_template.xls", "项目计划单-"
				+ order.getNo()
				+ ".xls", response, targetMap);
	}
}
