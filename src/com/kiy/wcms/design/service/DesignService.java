package com.kiy.wcms.design.service;

import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.Global;
import com.kiy.wcms.design.entity.Design;
import com.kiy.wcms.design.entity.DesignAtta;
import com.kiy.wcms.design.entity.DesignParam;
import com.kiy.wcms.design.entity.MaterialList;
import com.kiy.wcms.design.mapper.DesignAttaMapper;
import com.kiy.wcms.design.mapper.DesignMapper;
import com.kiy.wcms.design.mapper.MaterialListMapper;
import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.PageView;

@Transactional
@Service("designService")
public class DesignService {
	@Autowired
	private DesignMapper designMapper;
	@Autowired
	private DesignAttaMapper designAttaMapper;
	@Autowired
	private MaterialListMapper materialListMapper;
	@Autowired
	private AuditService auditService;
	/**
	 * 获取设计方案列表
	 * @param param
	 * @return
	 */
	public JSONObject getDesignList(DesignParam param) {
		List<Design> list = designMapper.getDesignList(param);
		int total = designMapper.getTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 保存附件
	 * @param designId
	 * @param path
	 * @param name
	 * @return
	 */
	public boolean saveOrderAtta(String designId, String path, String name) {
		designAttaMapper.save(designId, path, name);
		return true;
	}
	
	/**
	 * 获取附件列表
	 * @param id
	 * @return
	 */
	public JSONArray getAttaList(String id) {
		List<DesignAtta> list = designAttaMapper.getAttaList(id);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取附件路径
	 * @param attaId
	 * @return
	 */
	public String getAttaPath(String attaId) {
		return designAttaMapper.getAttaPath(attaId);
	}
	
	/**
	 * 删除附件
	 * @param attaId
	 * @return
	 */
	public boolean deleteOrderAtta(String attaId) {
		designAttaMapper.delete(attaId);
		return true;
	}
	
	/**
	 * 保存物料
	 * @param mater
	 * @return
	 */
	public boolean saveMater(MaterialList mater) {
		materialListMapper.save(mater);
		return true;
	}
	
	/**
	 * 获取物料列表
	 * @param begin
	 * @param rows
	 * @param id
	 * @return
	 */
	public JSONObject getMaterList(int begin, Integer rows, String id) {
		List<MaterialList> list = materialListMapper.getMaterList(begin, rows, id);
		int total = materialListMapper.getTotal(id);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 更新物料
	 * @param mater
	 * @return
	 */
	public boolean updateMater(MaterialList mater) {
		materialListMapper.update(mater);
		return true;
	}
	
	/**
	 * 删除物料
	 * @param id
	 * @return
	 */
	public boolean deleteMater(String id) {
		materialListMapper.delete(id);
		return true;
	}
	
	/**
	 * 提交设计方案
	 * @param id
	 * @return
	 */
	public boolean submitDesign(String id) {
		designMapper.submitDesign(id);
		return true;
	}
	
	/**
	 * 获取审批列表
	 * @param param
	 * @return
	 */
	public JSONObject getAuditDesignList(DesignParam param) {
		List<Design> list = designMapper.getAuditDesignList(param);
		int total = designMapper.getAuditTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 
	 * @param id
	 * @param option
	 * @param status
	 * @param comment
	 * @param user
	 * @return
	 */
	public boolean submitAudit(String id, String option, int status,
			String comment, SysUser user) {
		designMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_DESIGN);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		return true;
	}
	
	/**
	 * 获取被退回总数
	 * @return
	 */
	public int getBackTotal() {
		return designMapper.getBackTotal();
	}
	
	/**
	 * 获取未提交设计方案
	 * @return
	 */
	public int getUnPayTotal() {
		return designMapper.getUnPayTotal();
	}
	
	/**
	 * 获取未审批总数
	 * @param seeStatus
	 * @return
	 */
	public int getUnAuditTotal(String seeStatus) {
		DesignParam param = new DesignParam();
		param.setAuditStatus(0);
		param.setSeeStatus(seeStatus);
		return designMapper.getAuditTotal(param);
	}
}
