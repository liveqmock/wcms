package com.kiy.wcms.gather.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import com.kiy.wcms.gather.entity.Delivery;
import com.kiy.wcms.gather.entity.Gather;
import com.kiy.wcms.gather.entity.GatherParam;
import com.kiy.wcms.gather.entity.Logistics;
import com.kiy.wcms.gather.entity.Shipments;
import com.kiy.wcms.gather.entity.ShipmentsDetail;
import com.kiy.wcms.gather.service.GatherService;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;
import com.kiy.wcms.util.ExportExcel;

@Controller
@RequestMapping("/gather/")
public class GatherController {
	@Autowired
	private GatherService gatherService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private AuditService auditService;
	
	@RequestMapping("gatherInputManager")
	public String gatherInputManager(){
		return "/app/gatherAndShipments/gathering_entering_list";
	}
	
	/**
	 * 展示订单
	 * @param page
	 * @param rows
	 * @param response
	 */
	@RequestMapping("showOrders")
	public void showOrders(Integer page, Integer rows, GatherParam param,
			HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1)*rows;
		param.setBegin(begin);
		param.setRows(rows);
		
		JSONObject json = gatherService.showOrders(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 根据订单号获取收款单列表
	 * @param orderId
	 * @param page
	 * @param rows
	 * @param response
	 */
	@RequestMapping("getGatherListByOrderId")
	public void getGatherListByOrderId(String orderId, Integer page, Integer rows, 
			HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1) * rows;
		
		JSONObject json = gatherService.getGatherList(orderId, begin, rows);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存收款单
	 * @param gather
	 * @param response
	 * @param request
	 */
	@RequestMapping("saveGather")
	public void saveGather(Gather gather, HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		boolean flag = gatherService.saveGather(gather, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新收款单
	 * @param gather
	 * @param response
	 * @param request
	 */
	@RequestMapping("updateGather")
	public void updateGather(Gather gather, HttpServletResponse response){
		boolean flag = gatherService.updateGather(gather);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除请款单
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteGather")
	public void deleteGather(int id, HttpServletResponse response){
		boolean flag = gatherService.deleteGather(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交收款单
	 * @param id
	 * @param response
	 */
	@RequestMapping("submitGather")
	public void submitGather(int id, HttpServletResponse response){
		boolean flag = gatherService.submitGather(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 上传附件
	 * @param orderId
	 * @param file
	 * @param request
	 * @param response
	 */
	@RequestMapping("addAtta")
	public void addAtta(String gatherId, @RequestParam MultipartFile file, 
			HttpServletRequest request, HttpServletResponse response){
		String path = request.getSession().getServletContext().getRealPath("upload");
		path += File.separator + "gather" + File.separator + 
				new SimpleDateFormat("yyyy").format(new Date()) + File.separator + gatherId;
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
			boolean flag = gatherService.saveGatherAtta(gatherId, targetFile.getPath(), targetFile.getName());
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
	 * 获取收款单附件列表
	 * @param id
	 * @param response
	 */
	@RequestMapping("getGatherAttaList")
	public void getGatherAttaList(String id, HttpServletResponse response){
		JSONArray array = gatherService.getGatherAttaList(id);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 下载收款单附件
	 * @param path
	 * @param response
	 */
	@RequestMapping("downloadGatherAtta")
	public void downloadGatherAtta(String id, HttpServletResponse response){
		OutputStream out = null;
		
		String path = gatherService.getAttaPath(id);
		
		try {
			File file = new File(path);
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
	 * 删除收款单附件
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteGatherAtta")
	public void deleteGatherAtta(String id, HttpServletResponse response){
		boolean flag = gatherService.deleteGatherAtta(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到收款单审批页面
	 * @param request
	 * @param model
	 * @return
	 */
	@RequestMapping("gatherAuditManager")
	public String gatherAuditManager(HttpServletRequest request, Model model){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		//是否为销售部领导
		boolean isXSBLD = userService.isHasRole(user, "XSBLD");
		//是否为财务部领导
		boolean isCWBLD = userService.isHasRole(user, "CWBLD");
				
		String seeStatus = "";
		if(isXSBLD){
			seeStatus = "10";
		}else if(isCWBLD){
			seeStatus = "20";
		}
		model.addAttribute("seeStatus", seeStatus);
		return "/app/gatherAndShipments/gathering_approval_list";
	}
	
	/**
	 * 获取收款单审批列表
	 * @param param
	 * @param response
	 */
	@RequestMapping("getAuditGatheringList")
	public void getAuditGatheringList(Integer page, Integer rows, 
			GatherParam param, Integer auditStatus, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		
		if(rows == null){
			rows = 10;
		}
		
		if(auditStatus == null){
			auditStatus = 0;
		}
		
		int begin = (page-1) * rows;
		
		param.setBegin(begin);
		param.setRows(rows);
		param.setAuditStatus(auditStatus);
		
		JSONObject json = gatherService.getAuditGather(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取历史收款单
	 * @param id
	 * @param response
	 */
	@RequestMapping("getHisGatherList")
	public void getHisGatherList(String id, HttpServletResponse response){
		JSONArray array = gatherService.getHisGatherList(id);
		AjaxUtil.outputJsonArray(response, array);
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
		boolean flag = gatherService.submitAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到发货申请单录入页面
	 * @return
	 */
	@RequestMapping("shipmentsInput")
	public String shipmentsInput(){
		
		return "/app/gatherAndShipments/shipments_entering_list";
	}
	
	/**
	 * 跳转到发货申请单审批页面
	 * @return
	 */
	@RequestMapping("shipmentsAudit")
	public String shipmentsAudit(HttpServletRequest request, Model model){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		//是否为销售部领导
		boolean isXSBLD = userService.isHasRole(user, "XSBLD");
		//是否为财务部领导
		boolean isCWBLD = userService.isHasRole(user, "CWBLD");
		//是否为生产部领导
		boolean isSCLD = userService.isHasRole(user, "SCLD");
		//是否为质检
		boolean isZJ = userService.isHasRole(user, "ZJ");
		
		String seeStatus = "";
		if(isXSBLD){
			seeStatus = "10";
		}else if(isCWBLD){
			seeStatus = "15";
		}else if(isSCLD){
			seeStatus = "20";
		}else if(isZJ){
			seeStatus = "25";
		}
		model.addAttribute("seeStatus", seeStatus);
		return "/app/gatherAndShipments/shipments_approval_list";
	}
	
	/**
	 * 获取发货申请单列表
	 * @param page
	 * @param rows
	 * @param param
	 * @param response
	 */
	@RequestMapping("getShipOrderList")
	public void getShipOrderList(Integer page, Integer rows, GatherParam param, 
			HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1)*rows;
		param.setBegin(begin);
		param.setRows(rows);
		
		JSONObject json = gatherService.getShipOrderList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取订单详情及收款情况
	 * @param orderId
	 * @param response
	 */
	@RequestMapping("getGatherOrderById")
	public void getGatherOrderById(String orderId, HttpServletResponse response){
		JSONObject json = gatherService.getGatherOrderById(orderId);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 根据订单获取发货申请单列表
	 * @param orderId
	 * @param response
	 */
	@RequestMapping("getShipmentsByOrderId")
	public void getShipmentsByOrderId(String orderId, HttpServletResponse response){
		JSONArray array = gatherService.getShipmentsByOrderId(orderId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 创建发货申请单
	 * @param orderId
	 * @param response
	 */
	@RequestMapping("createShipment")
	public void createShipment(String orderId, HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		JSONObject json = gatherService.createShipment(orderId, user);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取发货申请单
	 * @param id
	 * @param response
	 */
	@RequestMapping("getShipmentById")
	public void getShipmentById(String id, HttpServletResponse response){
		JSONObject json = gatherService.getShipmentById(id);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新发货申请单
	 * @param ship
	 * @param response
	 */
	@RequestMapping("updateShipment")
	public void updateShipment(Shipments ship, HttpServletResponse response){
		boolean flag = gatherService.updateShipments(ship);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 根据订单ID获取明细
	 * @param orderId
	 * @param response
	 */
	@RequestMapping("getOrderDetailByOrderId")
	public void getOrderDetailByOrderId(String orderId, HttpServletResponse response){
		JSONArray array = gatherService.getOrderDetailByOrderId(orderId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 保存发货申请单明细
	 * @param detail
	 * @param response
	 */
	@RequestMapping("saveShipmentsDetail")
	public void saveShipmentsDetail(ShipmentsDetail detail, HttpServletResponse response){
		boolean flag = gatherService.saveShipmentsDetail(detail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取发货申请单明细
	 * @param shipmentsId
	 * @param response
	 */
	@RequestMapping("getShipmentsDetails")
	public void getShipmentsDetails(String shipmentsId, HttpServletResponse response){
		JSONArray array = gatherService.getShipmentsDetails(shipmentsId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 删除发货申请单明细
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteShipmentsDetail")
	public void deleteShipmentsDetail(String id, HttpServletResponse response){
		boolean flag = gatherService.deleteShipmentsDetail(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 上传附件
	 * @param orderId
	 * @param file
	 * @param request
	 * @param response
	 */
	@RequestMapping("addShipmentsAtta")
	public void addShipmentsAtta(String shipmentsId, @RequestParam MultipartFile file, 
			HttpServletRequest request, HttpServletResponse response){
		String path = request.getSession().getServletContext().getRealPath("upload");
		path += File.separator + "shipments" + File.separator + 
				new SimpleDateFormat("yyyy").format(new Date()) + File.separator + shipmentsId;
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
			boolean flag = gatherService.saveShipmentsAtta(shipmentsId, targetFile.getPath(), targetFile.getName());
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
	 * 获取发货申请单附件列表
	 * @param id
	 * @param response
	 */
	@RequestMapping("getShipmentsAttaList")
	public void getShipmentsAttaList(String id, HttpServletResponse response){
		JSONArray array = gatherService.getShipmentsAttaList(id);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 下载发货申请单附件
	 * @param id
	 * @param response
	 */
	@RequestMapping("downloadShipmentsAtta")
	public void downloadShipmentsAtta(String id, HttpServletResponse response){
		OutputStream out = null;
		
		String path = gatherService.getShipmentsAttaPath(id);
		
		try {
			File file = new File(path);
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
	 * 删除发货申请单附件
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteShipmentsAtta")
	public void deleteShipmentsAtta(String id, HttpServletResponse response){
		boolean flag = gatherService.deleteShipmentsAtta(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除发货申请单
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteShipments")
	public void deleteShipments(String id, HttpServletResponse response){
		boolean flag = gatherService.deleteShipments(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交发货申请单
	 * @param id
	 * @param response
	 */
	@RequestMapping("submitShipments")
	public void submitShipments(String id, HttpServletResponse response){
		boolean flag = gatherService.submitShipments(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取发货申请单审批列表
	 * @param page
	 * @param rows
	 * @param param
	 * @param auditStatus
	 * @param response
	 */
	@RequestMapping("getShipmentsAuditList")
	public void getShipmentsAuditList(Integer page, Integer rows, 
			GatherParam param, Integer auditStatus, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		
		if(rows == null){
			rows = 10;
		}
		
		if(auditStatus == null){
			auditStatus = 0;
		}
		
		int begin = (page-1) * rows;
		
		param.setBegin(begin);
		param.setRows(rows);
		param.setAuditStatus(auditStatus);
		
		JSONObject json = gatherService.getAuditShipments(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交审批信息
	 * @param id
	 * @param option
	 * @param seeStatus
	 * @param comment
	 * @param response
	 * @param request
	 */
	@RequestMapping("submitShipmentAudit")
	public void submitShipmentAudit(String id, String option, String seeStatus, String comment,
			HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		int status = 0;
		if("0".equals(option)){
			status = -5555;
		}else{
			status = 15;
			if("15".equals(seeStatus)){
				status = 20;
			}else if("20".equals(seeStatus)){
				status = 25;
			}else if("25".equals(seeStatus)){
				status = 30;
			}
		}
		boolean flag = gatherService.submitShipmentsAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到送货单录入界面
	 * @return
	 */
	@RequestMapping("deliveryInput")
	public String deliveryInput(){
		
		return "/app/gatherAndShipments/delivery_entering_list";
	}
	
	/**
	 * 获取送货单列表
	 * @param response
	 */
	@RequestMapping("getDeliveryList")
	public void getDeliveryList(Integer page, Integer rows, GatherParam param, 
			HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1) * rows;
		param.setBegin(begin);
		param.setRows(rows);
		
		JSONObject json = gatherService.getDeliveryList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新送货单
	 * @param delivery
	 * @param response
	 */
	@RequestMapping("updateDelivery")
	public void updateDelivery(Delivery delivery, HttpServletResponse response){
		boolean flag = gatherService.updateDelivery(delivery);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 生效送货单
	 * @param id
	 * @param response
	 */
	@RequestMapping("effectDelivery")
	public void effectDelivery(String id, HttpServletResponse response){
		boolean flag = gatherService.effectDelivery(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到物流情况录入页面
	 * @return
	 */
	@RequestMapping("logisticsInput")
	public String logisticsInput(){
		return "/app/gatherAndShipments/logistics_entering_list";
	}
	
	/**
	 * 新增物料情况
	 * @param logistics
	 * @param response
	 * @throws ParseException 
	 */
	@RequestMapping("addLogistics")
	public void addLogistics(Logistics logistics, HttpServletResponse response, HttpServletRequest request) throws ParseException{
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		logistics.setCreateUser(user.getId());
		logistics.setCreateTime(System.currentTimeMillis());
		boolean flag = gatherService.addLogistics(logistics);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取物流情况列表
	 * @param deliveryId
	 * @param response
	 */
	@RequestMapping("getLogisticsList")
	public void getLogisticsList(String deliveryId, HttpServletResponse response){
		JSONArray array = gatherService.getLogisticsList(deliveryId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 根据订单ID获取收款单列表
	 * @param orderId
	 * @param response
	 */
	@RequestMapping("getGathersByOrder")
	public void getGathersByOrder(String orderId, HttpServletResponse response){
		JSONArray array = gatherService.getGathersByOrder(orderId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 导出送货单
	 * @param id
	 */
	@RequestMapping("printDelivery")
	public void printDelivery(String id, HttpServletRequest request, HttpServletResponse response){
		ExportExcel export = new ExportExcel();
		Map<String,Object> targetMap = new HashMap<String, Object>();
		//将数据加入targetMap中
		//delivery基础数据
		Delivery delivery = gatherService.getDeliveryById(id);
		targetMap.put("delivery", delivery);
		//showList发货产品清单
		List<ShipmentsDetail> showList = gatherService.getShipDetailsByDeliId(id);
		targetMap.put("showlist", showList);
		
		String path = request.getSession().getServletContext()
				.getRealPath("/WEB-INF/template/");
		export.exportToStream(path + "/delivery_template.xls", "送货单+"
				+ new SimpleDateFormat("yyyyMMDDHHmm").format(new Date())
				+ ".xls", response, targetMap);
	}
}
