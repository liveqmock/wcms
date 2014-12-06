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
import com.kiy.wcms.procurementplan.entity.Accept;
import com.kiy.wcms.procurementplan.entity.AcceptParam;
import com.kiy.wcms.procurementplan.entity.ContractDetail;
import com.kiy.wcms.procurementplan.entity.ProcurementContract;
import com.kiy.wcms.procurementplan.entity.ProcurementContractParam;
import com.kiy.wcms.procurementplan.service.ContractService;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/contract/")
public class ContractController {
	@Autowired
	private UserService userService;
	@Autowired
	private ContractService contractService;
	/**
	 * 跳转到采购订单(合同)录入页面
	 * @return
	 */
	@RequestMapping("contractInput")
	public String contractInput(){
		return "/app/procurementPlan/contract_entering_list";
	}
	/**
	 * 跳转到采购订单(合同)审批页面
	 * @return
	 */
	@RequestMapping("contractAudit")
	public String contractAudit(HttpServletRequest request, Model model){
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
		return "/app/procurementPlan/contract_approval_list";
	}
	/**
	 * 获取采购订单列表
	 * @param page
	 * @param rows
	 * @param rocurementContractParam
	 * @param response
	 */
	@RequestMapping("getProcurementContractList")
	public void getProcurementContractList(Integer page, Integer rows, 
			ProcurementContractParam rocurementContractParam, HttpServletResponse response){
		if(page==null){
			page = 1;
		}
		if(rows==null){
			rows = 10;
		}
		int begin = (page-1) * rows;
		rocurementContractParam.setBegin(begin);
		rocurementContractParam.setRows(rows);
		JSONObject json = contractService.getProcurementContractList(rocurementContractParam);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 保存采购订单
	 * @param rocurementContract
	 * @param response
	 * @param request
	 */
	@RequestMapping("saveContract")
	public void saveContract(ProcurementContract rocurementContract, HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		rocurementContract.setCreateUser(user);
		contractService.saveContract(rocurementContract);
		JSONObject json = new JSONObject();
		json.put("flag", true);
		json.put("data", JSONObject.fromObject(rocurementContract));
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 更新采购订单
	 * @param rocurementContract
	 * @param response
	 */
	@RequestMapping("updateContract")
	public void updateContract(ProcurementContract rocurementContract, HttpServletResponse response){
		contractService.updateContract(rocurementContract);
		JSONObject json = new JSONObject();
		json.put("flag", true);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 获取采购订单明细列表
	 * @param contractId
	 * @param response
	 */
	@RequestMapping("getDetailList")
	public void getDetailList(String contractId, HttpServletResponse response){
		JSONArray array = contractService.getDetailList(contractId);
		AjaxUtil.outputJsonArray(response, array);
	}
	/**
	 * 保存采购订单明细信息
	 * @param contractDetail
	 * @param response
	 */
	@RequestMapping("saveDetail")
	public void saveDetail(ContractDetail contractDetail, HttpServletResponse response){
		boolean flag = contractService.saveDetail(contractDetail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 编辑采购订单明细信息
	 * @param contractDetail
	 * @param response
	 */
	@RequestMapping("updateDetail")
	public void updateDetail(ContractDetail contractDetail, HttpServletResponse response){
		boolean flag = contractService.updateDetail(contractDetail);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 删除采购订单明细信息
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteDetail")
	public void deleteDetail(String id, HttpServletResponse response){
		boolean flag = contractService.deleteDetail(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 上传采购订单附件
	 * @param contractId
	 * @param file
	 * @param request
	 * @param response
	 */
	@RequestMapping("addAtta")
	public void addAtta(String contractId, @RequestParam MultipartFile file, 
			HttpServletRequest request, HttpServletResponse response){
		String path = request.getSession().getServletContext().getRealPath("upload");
		path += File.separator + "contract" + File.separator + new SimpleDateFormat("yyyy").format(new Date()) + File.separator + contractId;
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
			boolean flag = contractService.saveContractAtta(contractId, targetFile.getPath(), targetFile.getName());
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
	 * @param contractId
	 * @param response
	 */
	@RequestMapping("getContractAttaList")
	public void getContractAttaList(String contractId, HttpServletResponse response){
		JSONArray array = contractService.getContractAttaList(contractId);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 删除附件
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteContractAtta")
	public void deleteContractAtta(String id, HttpServletResponse response){
		boolean flag = contractService.deleteContractAtta(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	/**
	 * 下载附件
	 * @param id
	 * @param response
	 */
	@RequestMapping("downloadContractAtta")
	public void downloadContractAtta(String id, HttpServletResponse response){
		OutputStream out = null;
        
		String attaPath = contractService.getAttaPath(id);
		
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
	 * 删除采购订单
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteContract")
	public void deleteContract(String id, HttpServletResponse response){
		boolean flag = contractService.deleteContract(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
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
		boolean flag = contractService.submitAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交合同
	 * @param id
	 * @param response
	 */
	@RequestMapping("submitContract")
	public void submitContract(String id, HttpServletResponse response){
		boolean flag = contractService.submitContract(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取审批列表
	 * @param page
	 * @param rows
	 * @param auditStatus
	 * @param param
	 * @param response
	 */
	@RequestMapping("getAuditList")
	public void getAuditList(Integer page, Integer rows, 
			Integer auditStatus, ProcurementContractParam param, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		if(auditStatus == null){
			auditStatus = 0;
		}
		int begin = (page-1)*rows;
		param.setBegin(begin);
		param.setAuditStatus(auditStatus);
		JSONObject json = contractService.getAuditList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到验收页面
	 * @return
	 */
	@RequestMapping("accept")
	public String accept(){
		return "/app/procurementPlan/acceptance_list";
	}
	
	/**
	 * 获取待验收物品列表
	 * @param page
	 * @param rows
	 * @param param
	 * @param response
	 */
	@RequestMapping("getAcceptItemList")
	public void getAcceptItemList(Integer page, Integer rows, AcceptParam param, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1)*rows;
		param.setBegin(begin);
		param.setRows(rows);
		JSONObject json = contractService.getAcceptItemList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 新增验收记录
	 * @param accept
	 * @param request
	 * @param response
	 */
	@RequestMapping("addAccept")
	public void addAccept(Accept accept, HttpServletRequest request, HttpServletResponse response){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		boolean flag = contractService.addAccept(accept, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
}
