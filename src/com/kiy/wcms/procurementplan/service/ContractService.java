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
import com.kiy.wcms.entrepot.entity.EntrepotLog;
import com.kiy.wcms.entrepot.service.EntrepotService;
import com.kiy.wcms.procurementplan.entity.Accept;
import com.kiy.wcms.procurementplan.entity.AcceptItem;
import com.kiy.wcms.procurementplan.entity.AcceptParam;
import com.kiy.wcms.procurementplan.entity.ContractAtta;
import com.kiy.wcms.procurementplan.entity.ContractDetail;
import com.kiy.wcms.procurementplan.entity.ProcurementContract;
import com.kiy.wcms.procurementplan.entity.ProcurementContractParam;
import com.kiy.wcms.procurementplan.mapper.AcceptMapper;
import com.kiy.wcms.procurementplan.mapper.ContractAttaMapper;
import com.kiy.wcms.procurementplan.mapper.ContractDetailMapper;
import com.kiy.wcms.procurementplan.mapper.ProcurementContractMapper;
import com.kiy.wcms.procurementplan.mapper.ProcurementDetailMapper;
import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.PageView;
import com.kiy.wcms.util.SimpleDateUtil;

@Transactional
@Service("contractService")
public class ContractService {
	@Autowired
	private ProcurementContractMapper procurementContractMapper;
	@Autowired
	private ContractDetailMapper contractDetailMapper;
	@Autowired
	private ContractAttaMapper contractAttaMapper;
	@Autowired
	private AcceptMapper acceptMapper;
	@Autowired
	private ProcurementDetailMapper procurementDetailMapper;
	@Autowired
	private EntrepotService entrepotService;
	@Autowired
	private AuditService auditService;
	/**
	 * 获取采购订列表
	 * @param procurementContractParam
	 * @return
	 */
	public JSONObject getProcurementContractList(
			ProcurementContractParam param) {
		if(param.getReceiveTimeBegin()!=null&&!param.getReceiveTimeBegin().equals("")){
			param.setReceiveTimeBegin(SimpleDateUtil.convert2long(param.getReceiveTimeBegin(), SimpleDateUtil.DATE_FORMAT)+"");
		}
		if(param.getReceiveTimeEnd()!=null&&!param.getReceiveTimeEnd().equals("")){
			param.setReceiveTimeEnd(SimpleDateUtil.convert2long(param.getReceiveTimeEnd(), SimpleDateUtil.DATE_FORMAT)+"");
		}
		if(param.getSignDateBegin()!=null&&!param.getSignDateBegin().equals("")){
			param.setSignDateBegin(SimpleDateUtil.convert2long(param.getSignDateBegin(), SimpleDateUtil.DATE_FORMAT)+"");
		}
		if(param.getSignDateEnd()!=null&&!param.getSignDateEnd().equals("")){
			param.setSignDateEnd(SimpleDateUtil.convert2long(param.getSignDateEnd(), SimpleDateUtil.DATE_FORMAT)+"");
		}
		List<ProcurementContract> list = procurementContractMapper.getProcurementContractList(param);
		int total = procurementContractMapper.getTotal(param);
		PageView page = new PageView(total, list);
		return JSONObject.fromObject(page);
	}
	/**
	 * 保存采购订单
	 * @param rocurementContract
	 */
	public void saveContract(ProcurementContract rocurementContract) {
		String code = getNextCode(rocurementContract);
		rocurementContract.setCode(code);
		rocurementContract.setSignDate(SimpleDateUtil.convert2long(
				rocurementContract.getSignDateStr(), SimpleDateUtil.DATE_FORMAT));
		rocurementContract.setReceiveTime(SimpleDateUtil.convert2long(
				rocurementContract.getReceiveTimeStr(), SimpleDateUtil.DATE_FORMAT));
		rocurementContract.setCreateDate(System.currentTimeMillis());
		procurementContractMapper.save(rocurementContract);
	}
	/**
	 * 获取下一个采购计划编号流水号
	 * @return
	 */
	private String getNextCode(ProcurementContract procurementContract) {
		String prefix = "";
		String code = "";
		if(procurementContract.getCompany().trim().equals("大通")){
			code = "D" + new SimpleDateFormat("yyyyMM").format(new Date());
			prefix = "D" + new SimpleDateFormat("yyyyMM").format(new Date());
		}else if(procurementContract.getCompany().trim().equals("四海大通")){
			code = "M" + new SimpleDateFormat("yyyyMM").format(new Date());
			prefix = "M" + new SimpleDateFormat("yyyyMM").format(new Date());
		}
		Integer nextNo = procurementContractMapper.getNextCode(prefix);
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		for(int i=noStr.length();i<4;i++){
			code += "0";
		}
		
		code += noStr;
		return code;
	}
	/**
	 * 获取采购订单明细列表
	 * @param contractId
	 * @return 
	 */
	public JSONArray getDetailList(String contractId) {
		List<ContractDetail> list = contractDetailMapper.getDetailList(contractId);
		return JSONArray.fromObject(list);
	}
	/**
	 * 更新采购订单
	 * @param rocurementContract
	 */
	public void updateContract(ProcurementContract rocurementContract) {
		rocurementContract.setSignDate(SimpleDateUtil.convert2long(
				rocurementContract.getSignDateStr(), SimpleDateUtil.DATE_FORMAT));
		rocurementContract.setReceiveTime(SimpleDateUtil.convert2long(
				rocurementContract.getReceiveTimeStr(), SimpleDateUtil.DATE_FORMAT));
		procurementContractMapper.update(rocurementContract);
	}
	/**
	 * 保存采购订单明细信息
	 * @param contractDetail
	 * @return
	 */
	public boolean saveDetail(ContractDetail contractDetail) {
		procurementDetailMapper.saveDetail(contractDetail);
		contractDetailMapper.saveDetail(contractDetail);
		return true;
	}
	/**
	 * 编辑采购订单明细信息
	 * @param contractDetail
	 * @return
	 */
	public boolean updateDetail(ContractDetail contractDetail) {
		contractDetailMapper.updateDetail(contractDetail);
		return true;
	}
	/**
	 * 删除采购订单明细信息
	 * @param id
	 * @return
	 */
	public boolean deleteDetail(String id) {
		contractDetailMapper.deleteDetail(id);
		return true;
	}
	/**
	 * 保存附件
	 * @param contractId
	 * @param filePath
	 * @param fileName
	 * @return
	 */
	public boolean saveContractAtta(String contractId, String filePath, String fileName) {
		contractAttaMapper.save(contractId, filePath, fileName);
		return true;
	}

	/**
	 * 获取附件列表
	 * @param contractId
	 * @return
	 */
	public JSONArray getContractAttaList(String contractId) {
		List<ContractAtta> list = contractAttaMapper.getAll(contractId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 删除附件
	 * @param attaId
	 * @return
	 */
	public boolean deleteContractAtta(String id) {
		contractAttaMapper.delete(id);
		return true;
	}
	
	/**
	 * 获取附件路径
	 * @param attaId
	 * @return
	 */
	public String getAttaPath(String id) {
		return contractAttaMapper.getAttaPath(id);
	}
	/**
	 * 删除采购订单
	 * @param id
	 * @param response
	 */
	public boolean deleteContract(String id) {
		//删除附件信息
		contractAttaMapper.deleteAttaByContractId(id);
		//删除采购订单明细
		contractDetailMapper.deleteContractDetailByContractId(id);
		//删除采购订单
		procurementContractMapper.deleteContract(id);
		return true;
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
		procurementContractMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_PROCUREMENTCONTRACT);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		
		return true;
	}
	
	/**
	 * 提交合同
	 * @param id
	 * @return
	 */
	public boolean submitContract(String id) {
		procurementContractMapper.submitContract(id);
		return true;
	}
	
	/**
	 * 获取审批列表
	 * @param param
	 * @return
	 */
	public JSONObject getAuditList(ProcurementContractParam param) {
		List<ProcurementContract> list = procurementContractMapper.getAuditList(param);
		int total = procurementContractMapper.getAuditTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 获取待验收列表
	 * @param param
	 * @return
	 */
	public JSONObject getAcceptItemList(AcceptParam param) {
		List<AcceptItem> list = acceptMapper.getAcceptItemList(param);
		int total = acceptMapper.getAcceptTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 新增验收记录
	 * @param accept
	 * @param user
	 * @return
	 */
	public boolean addAccept(Accept accept, SysUser user) {
		EntrepotLog log = new EntrepotLog();
		log.setAmount(accept.getAmount());
		log.setCode(entrepotService.getNextInEntrepotCode());
		log.setCreateTime(System.currentTimeMillis());
		log.setCreateUser(user.getId());
		log.setEntrepotId(accept.getEntrepot());
		log.setGoodsId(accept.getGoodsId());
		log.setReceiveUserId(user.getId());
		log.setRemark(accept.getRemark());
		log.setShelfId(accept.getShelf());
		log.setType(0);
		log.setUnitPrice(accept.getPrice());
		boolean flag = entrepotService.inEntrepot(log);
		if(flag){
			accept.setCheckDate(System.currentTimeMillis());
			accept.setCheckUser(user.getId());
			accept.setCreateDate(System.currentTimeMillis());
			accept.setCreateUser(user.getId());
			acceptMapper.addAccept(accept);
		}
		return true;
	}
	
	/**
	 * 获取采购订单被退回总数
	 * @return
	 */
	public int getBackTotal() {
		return procurementContractMapper.getBackTotal();
	}
	
	/**
	 * 采购订单待审批总数
	 * @param seeStatus
	 * @return
	 */
	public int getUnAuditTotal(String seeStatus) {
		ProcurementContractParam param = new ProcurementContractParam();
		param.setAuditStatus(0);
		param.setSeeStatus(seeStatus);
		return procurementContractMapper.getAuditTotal(param);
	}
}
