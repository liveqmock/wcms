package com.kiy.wcms.procurementplan.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.Global;
import com.kiy.wcms.order.entity.OrderAtta;
import com.kiy.wcms.procurementplan.entity.ProcurementDetail;
import com.kiy.wcms.procurementplan.entity.ProcurementDetailParam;
import com.kiy.wcms.procurementplan.entity.ProcurementPlanParam;
import com.kiy.wcms.procurementplan.entity.ProcurementPlan;
import com.kiy.wcms.procurementplan.mapper.ProcurementAttaMapper;
import com.kiy.wcms.procurementplan.mapper.ProcurementDetailMapper;
import com.kiy.wcms.procurementplan.mapper.ProcurementPlanMapper;
import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.PageView;

@Transactional
@Service("procurementPlanService")
public class ProcurementPlanService {
	@Autowired
	private ProcurementPlanMapper procurementPlanMapper;
	@Autowired
	private ProcurementDetailMapper procurementDetailMapper;
	@Autowired
	private ProcurementAttaMapper procurementAttaMapper;
	@Autowired
	private AuditService auditService;
	/**
	 * 获取采购计划列表
	 * @param procurementPlanParam
	 * @return
	 */
	public JSONObject getProcurementPlanList(
			ProcurementPlanParam procurementPlanParam) {
		// TODO Auto-generated method stub
		List<ProcurementPlan> list = procurementPlanMapper.getProcurementPlanList(procurementPlanParam);
		int total = procurementPlanMapper.getTotal(procurementPlanParam);
		PageView page = new PageView(total, list);
		return JSONObject.fromObject(page);
	}
	
	/**
	 * 保存采购计划
	 * @param procurementPlan
	 * @return
	 */
	public int saveProcurementPlan(ProcurementPlan procurementPlan) {
		// TODO Auto-generated method stub
		String code = getNextCode();
		procurementPlan.setCode(code);
		procurementPlanMapper.save(procurementPlan);
		return procurementPlan.getId();
	}
	
	/**
	 * 获取下一个采购计划编号流水号
	 * @return
	 */
	private String getNextCode() {
		Integer nextNo = procurementPlanMapper.getNextCode();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String code = "ST-" + new SimpleDateFormat("yyyy").format(new Date());
		
		for(int i=noStr.length();i<4;i++){
			code += "0";
		}
		
		code += noStr;
		return code;
	}
	/**
	 * 获取采购计划明细信息
	 * @param planId
	 */
	public JSONArray getProcurementDetailList(String planId) {
		// TODO Auto-generated method stub
		List<ProcurementDetail> list = procurementDetailMapper.getProcurementDetailList(planId);
		return JSONArray.fromObject(list);
	}
	/**
	 * 保存采购计划明细信息
	 * @param procurementDetail
	 */
	public boolean saveProcurementDetail(ProcurementDetail procurementDetail) {
		// TODO Auto-generated method stub
		procurementDetailMapper.saveProcurementDetail(procurementDetail);
		return true;
	}
	/**
	 * 修改采购计划明细信息
	 * @param procurementDetail
	 */
	public boolean updateProcurementDetail(ProcurementDetail procurementDetail) {
		// TODO Auto-generated method stub
		procurementDetailMapper.updateProcurementDetail(procurementDetail);
		return true;
	}
	/**
	 * 更新采购计划
	 * @param procurementPlan
	 */
	public boolean updateProcurementPlan(ProcurementPlan procurementPlan) {
		// TODO Auto-generated method stub
		procurementPlanMapper.updateProcurementPlan(procurementPlan);
		return true;
	}
//	/**
//	 * 获取物品库信息
//	 */
//	public JSONArray addProcurementDetailList() {
//		// TODO Auto-generated method stub
//		List<ProcurementDetailParam> list = procurementDetailMapper.addProcurementDetailList();
//		return JSONArray.fromObject(list);
//	}
	/**
	 * 删除采购计划明细信息
	 * @param detailId
	 * @return
	 */
	public boolean deleteProcurementDetail(String detailId) {
		// TODO Auto-generated method stub
		procurementDetailMapper.deleteProcurementDetail(detailId);
		return true;
	}
	/**
	 * 删除采购计划
	 * @param id
	  * @return
	 */
	public boolean deleteProcurementPlan(String id) {
		// TODO Auto-generated method stub
		procurementAttaMapper.deleteByPlanId(id);
		procurementDetailMapper.deleteProcurementDetailByPlanId(id);
		procurementPlanMapper.deleteProcurementPlan(id);
		return true;
	}

	/**
	 * 保存附件
	 * @param planId
	 * @param path
	 * @param fileName
	 * @return
	 */
	public boolean saveProcurementPlanAtta(String planId, String path, String fileName) {
		procurementAttaMapper.save(planId, path, fileName);
		return true;
	}

	/**
	 * 获取附件列表
	 * @param planId
	 * @return
	 */
	public JSONArray getProcurementPlanAttaList(String planId) {
		List<OrderAtta> list = procurementAttaMapper.getAll(planId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 删除附件
	 * @param attaId
	 * @return
	 */
	public boolean deleteProcurementPlanAtta(String attaId) {
		procurementAttaMapper.delete(attaId);
		return true;
	}
	
	/**
	 * 获取附件路径
	 * @param attaId
	 * @return
	 */
	public String getAttaPath(String attaId) {
		return procurementAttaMapper.getAttaPath(attaId);
	}

	/**
	 * 保存审批信息
	 * @param id
	 * @param option
	 * @param status
	 * @param user
	 * @return
	 */
	public boolean submitAudit(String id, String option, int status, String comment,
			SysUser user) {
		procurementPlanMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_PROCUREMENTPLAN);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		
		return true;
	}
	/**
	 * 通过条件查询获取采购计划列表信息
	 * @param procurementDetailParam
	 * @return 
	 */
	public JSONObject getPlanListByCondition(
			ProcurementDetailParam procurementDetailParam) {
		List<ProcurementDetailParam> list = procurementDetailMapper.getPlanListByCondition(procurementDetailParam);
		int total = procurementDetailMapper.getPlanDetailListTotal(procurementDetailParam);
		PageView page = new PageView(total, list);
		return JSONObject.fromObject(page);
	}
	
	/**
	 * 提交采购计划
	 * @param id
	 * @return
	 */
	public boolean submitPlan(String id) {
		procurementPlanMapper.submitPlan(id);
		return true;
	}
	
	public JSONObject getAuditPlanList(
			ProcurementPlanParam procurementPlanParam) {
		List<ProcurementPlan> list = procurementPlanMapper
				.getAuditPlanList(procurementPlanParam);
		int total = procurementPlanMapper.getAuditTotal(procurementPlanParam);
		PageView page = new PageView(total, list);
		return JSONObject.fromObject(page);
	}
	
	/**
	 * 获取被退回采购计划总数
	 * @return
	 */
	public int getBackTotal() {
		
		return procurementPlanMapper.getBackTotal();
	}
	
	/**
	 * 获取待审批总数
	 * @param seeStatus
	 * @return
	 */
	public int getUnAuditTotal(String seeStatus) {
		if(seeStatus != null && seeStatus.equals("")){
			seeStatus = "-1";
		}
		ProcurementPlanParam param = new ProcurementPlanParam();
		param.setAuditStatus(0);
		param.setSeeStatus(Integer.parseInt(seeStatus));
		return procurementPlanMapper.getAuditTotal(param);
	}
}
