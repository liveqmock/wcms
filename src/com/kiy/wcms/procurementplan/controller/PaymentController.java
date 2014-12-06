package com.kiy.wcms.procurementplan.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
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
import com.kiy.wcms.procurementplan.entity.Payment;
import com.kiy.wcms.procurementplan.entity.PaymentParam;
import com.kiy.wcms.procurementplan.service.PaymentService;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;
import com.kiy.wcms.util.ExportExcel;

@Controller
@RequestMapping("/payment/")
public class PaymentController {
	@Autowired
	private PaymentService paymentService;
	@Autowired
	private UserService userService;
	/**
	 * 跳转到付款申请单录入页面
	 * @return
	 */
	@RequestMapping("paymentInput")
	public String paymentInput(){
		return "/app/procurementPlan/payment_request_entering_list";
	}
	
	/**
	 * 获取已生效采购订单列表
	 * @param page
	 * @param rows
	 * @param response
	 */
	@RequestMapping("getContractList")
	public void getContractList(Integer page, Integer rows, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		int begin = (page - 1) * rows;
		JSONObject json = paymentService.getContractList(begin, rows);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取付款申请单列表
	 * @param contractId
	 * @param response
	 */
	@RequestMapping("getPaymentList")
	public void getPaymentList(String contractId, HttpServletResponse response){
		JSONArray array = paymentService.getPaymentList(contractId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 获取付款申请单列表
	 * @param paymentId
	 * @param response
	 */
	@RequestMapping("getPaymentAttaList")
	public void getPaymentAttaList(String paymentId, HttpServletResponse response){
		JSONArray array = paymentService.getPaymentAttaList(paymentId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 下载付款申请单附件
	 * @param id
	 * @param response
	 */
	@RequestMapping("downloadPaymentAtta")
	public void downloadPaymentAtta(String id, HttpServletResponse response){
		OutputStream out = null;
		
		String path = paymentService.getPaymentAttaPath(id);
		
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
	 * 保存付款申请单
	 * @param payment
	 * @param response
	 * @throws ParseException 
	 */
	@RequestMapping("savePayment")
	public void savePayment(Payment payment,HttpServletRequest request, HttpServletResponse response) throws ParseException{
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		payment.setCreateUser(user.getId());
		payment.setApplyUser(user.getId());
		boolean flag = paymentService.savePayment(payment);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新付款申请单
	 * @param payment
	 * @param response
	 * @throws ParseException 
	 */
	@RequestMapping("updatePayment")
	public void updatePayment(Payment payment, HttpServletRequest request, 
			HttpServletResponse response) throws ParseException{
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		payment.setApplyUser(user.getId());
		boolean flag = paymentService.updatePayment(payment);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存附件
	 */
	@RequestMapping("addAtta")
	public void addAtta(String paymentId, @RequestParam MultipartFile file, 
			HttpServletRequest request, HttpServletResponse response){
		
		String path = request.getSession().getServletContext().getRealPath("upload");
		path += File.separator + "payment" + File.separator + 
				new SimpleDateFormat("yyyy").format(new Date()) + File.separator + paymentId;
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
			boolean flag = paymentService.saveShipmentsAtta(paymentId, targetFile.getPath(), targetFile.getName());
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
	 * 删除付款申请单附件
	 * @param id
	 * @param response
	 */
	@RequestMapping("deletePaymentAtta")
	public void deletePaymentAtta(String id, HttpServletResponse response){
		boolean flag = paymentService.deletePaymentAtta(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除付款申请单
	 * @param id
	 * @param response
	 */
	@RequestMapping("deletePayment")
	public void deletePayment(String id, HttpServletResponse response){
		boolean flag = paymentService.deletePayment(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交付款申请单
	 * @param id
	 * @param response
	 */
	@RequestMapping("submitPayment")
	public void submitPayment(String id, HttpServletResponse response){
		boolean flag = paymentService.submitPayment(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到付款申请单审批页面
	 * @param model
	 */
	@RequestMapping("paymentAudit")
	public String paymentAudit(HttpServletRequest request, Model model){
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
		return "/app/procurementPlan/payment_request_approval_list";
	}
	
	/**
	 * 获取付款申请单审批列表
	 * @param param
	 * @param response
	 * @throws ParseException 
	 */
	@RequestMapping("getAuditPaymentList")
	public void getAuditGatheringList(Integer page, Integer rows, 
			PaymentParam param, Integer auditStatus, HttpServletResponse response) throws ParseException{
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
		
		JSONObject json = paymentService.getAuditPayment(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取历史付款申请单
	 * @param id
	 * @param response
	 */
	@RequestMapping("getHisPaymentList")
	public void getHisPaymentList(String id, HttpServletResponse response){
		JSONArray array = paymentService.getHisPaymentList(id);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param seeStatus
	 * @param comment
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
		boolean flag = paymentService.submitAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 导出付款申请单
	 */
	@RequestMapping("printPayment")
	public void printPayment(String id, HttpServletRequest request, HttpServletResponse response){
		ExportExcel export = new ExportExcel();
		Map<String,Object> targetMap = new HashMap<String, Object>();
		//将数据加入targetMap中
		//payment基础数据
		Payment payment = paymentService.getPaymentById(id);
		targetMap.put("payment", payment);
		String path = request.getSession().getServletContext()
				.getRealPath("/WEB-INF/template/");
		export.exportToStream(path + "/payment_template.xls", "付款申请单-"
				+ payment.getCode()
				+ ".xls", response, targetMap);
	}
}
