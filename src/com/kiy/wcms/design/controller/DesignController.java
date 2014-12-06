package com.kiy.wcms.design.controller;

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
import com.kiy.wcms.design.entity.DesignParam;
import com.kiy.wcms.design.entity.MaterialList;
import com.kiy.wcms.design.service.DesignService;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.UserService;
import com.kiy.wcms.util.AjaxUtil;

@Controller
@RequestMapping("/design/")
public class DesignController {
	@Autowired
	private DesignService designService;
	@Autowired
	private UserService userService;
	
	/**
	 * 跳转到设计方案录入页面
	 * @return
	 */
	@RequestMapping("inputManager")
	public String inputManager(){
		return "/app/design/design_entering_list";
	}
	
	/**
	 * 获取设计方案列表
	 * @param param
	 * @param response
	 */
	@RequestMapping("getDesignList")
	public void getDesignList(Integer page, Integer rows, DesignParam param, 
			HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		param.setBegin((page-1)*rows);
		param.setRows(rows);
		
		JSONObject json = designService.getDesignList(param);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 上传附件
	 */
	@RequestMapping("addAtta")
	public void addAtta(String designId, @RequestParam MultipartFile file, 
			HttpServletRequest request, HttpServletResponse response){
		String path = request.getSession().getServletContext().getRealPath("upload");
		path += File.separator + "design" + File.separator + new SimpleDateFormat("yyyy").format(new Date()) + File.separator + designId;
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
			boolean flag = designService.saveOrderAtta(designId, targetFile.getPath(), targetFile.getName());
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
	 * @param id
	 * @param response
	 */
	@RequestMapping("getAttaList")
	public void getAttaList(String id, HttpServletResponse response){
		JSONArray array = designService.getAttaList(id);
		AjaxUtil.outputJsonArray(response, array);
	}
	
	/**
	 * 下载附件
	 * @param attaId
	 * @param response
	 */
	@RequestMapping("downloadAtta")
	public void downloadAtta(String attaId, HttpServletResponse response){
		OutputStream out = null;
        
		String attaPath = designService.getAttaPath(attaId);
		
		try {
			File file = new File(attaPath);
			response.reset();  
	        response.setHeader("Content-Disposition", "attachment; filename="+URLEncoder.encode(file.getName(), "UTF-8"));  
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
	 * 删除附件
	 * @param attaId
	 * @param response
	 */
	@RequestMapping("deleteAtta")
	public void deleteAtta(String attaId, HttpServletResponse response){
		String attaPath = designService.getAttaPath(attaId);
		File file = new File(attaPath);
		file.delete();
		boolean flag = designService.deleteOrderAtta(attaId);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 保存物料
	 * @param mater
	 * @param response
	 */
	@RequestMapping("saveMater")
	public void saveMater(MaterialList mater, HttpServletResponse response){
		boolean flag = designService.saveMater(mater);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 获取物料列表
	 * @param id
	 * @param response
	 */
	@RequestMapping("getMaterList")
	public void getMaterList(Integer page, Integer rows, String id, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1) * rows;
		
		JSONObject json = designService.getMaterList(begin, rows ,id);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 更新物料
	 * @param mater
	 * @param response
	 */
	@RequestMapping("updateMater")
	public void updateMater(MaterialList mater, HttpServletResponse response){
		boolean flag = designService.updateMater(mater);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 删除物料
	 * @param id
	 * @param response
	 */
	@RequestMapping("deleteMater")
	public void deleteMater(String id, HttpServletResponse response){
		boolean flag = designService.deleteMater(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 提交设计方案
	 * @param id
	 * @param response
	 */
	@RequestMapping("submitDesign")
	public void submitDesign(String id, HttpServletResponse response){
		boolean flag = designService.submitDesign(id);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
	
	/**
	 * 跳转到设计方案审批页面
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping("auditManager")
	public String auditManager(Model model, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		//是否为技术部领导
		boolean isJSBLD = userService.isHasRole(user, "JSBLD");
		
		String seeStatus = "";
		if(isJSBLD){
			seeStatus = "10";
		}
		model.addAttribute("seeStatus", seeStatus);
		return "/app/design/design_approval_list";
	}
	
	/**
	 * 获取审批列表
	 * @param seeStatus
	 * @param response
	 */
	@RequestMapping("getAuditDesignList")
	public void getAuditDesignList(Integer page, Integer rows, Integer auditStatus, String seeStatus, 
			DesignParam param, HttpServletResponse response){
		if(page == null){
			page = 1;
		}
		if(rows == null){
			rows = 10;
		}
		
		int begin = (page-1)*rows;
		
		if(auditStatus == null){
			auditStatus = 0;
		}
		
		param.setAuditStatus(auditStatus);
		param.setBegin(begin);
		param.setRows(rows);
		
		JSONObject json = designService.getAuditDesignList(param);
		AjaxUtil.outputJson(response, json);
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
	public void submitAudit(String id, String option,  String comment,
			HttpServletResponse response, HttpServletRequest request){
		SysUser user = (SysUser) request.getSession().getAttribute(Global.LOGIN_USER);
		int status = 0;
		if("0".equals(option)){
			status = -5555;
		}else{
			status = 30;
		}
		boolean flag = designService.submitAudit(id, option, status, comment, user);
		JSONObject json = new JSONObject();
		json.put("flag", flag);
		AjaxUtil.outputJson(response, json);
	}
}
