package com.kiy.wcms.procurementplan.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.Global;
import com.kiy.wcms.procurementplan.entity.Contract;
import com.kiy.wcms.procurementplan.entity.Payment;
import com.kiy.wcms.procurementplan.entity.PaymentAtta;
import com.kiy.wcms.procurementplan.entity.PaymentParam;
import com.kiy.wcms.procurementplan.mapper.PaymentAttaMapper;
import com.kiy.wcms.procurementplan.mapper.PaymentMapper;
import com.kiy.wcms.sys.entity.Audit;
import com.kiy.wcms.sys.entity.SysUser;
import com.kiy.wcms.sys.service.AuditService;
import com.kiy.wcms.util.PageView;

@Transactional
@Service("paymentService")
public class PaymentService {
	@Autowired
	private PaymentMapper paymentMapper;
	@Autowired
	private PaymentAttaMapper paymentAttaMapper;
	@Autowired
	private AuditService auditService;
	
	/**
	 * 获取已生效的合同列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public JSONObject getContractList(int begin, Integer rows) {
		List<Contract> list = paymentMapper.getContractList(begin, rows);
		int total = paymentMapper.getContractTotal();
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 获取付款申请单列表
	 * @param contractId
	 * @return
	 */
	public JSONArray getPaymentList(String contractId) {
		List<Payment> list = paymentMapper.getPaymentList(contractId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取付款申请单列表
	 * @param paymentId
	 * @return
	 */
	public JSONArray getPaymentAttaList(String paymentId) {
		List<PaymentAtta> list = paymentAttaMapper.getList(paymentId);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 获取付款申请单附件路径
	 * @param id
	 * @return
	 */
	public String getPaymentAttaPath(String id) {
		return paymentAttaMapper.getPath(id);
	}
	
	/**
	 * 保存付款申请单
	 * @param payment
	 * @return
	 * @throws ParseException 
	 */
	public boolean savePayment(Payment payment) throws ParseException {
		payment.setApplyDate(new SimpleDateFormat("yyyy-MM-dd").parse(payment.getApplyDateStr()).getTime());
		payment.setCode(getNextCode());
		payment.setCreateDate(System.currentTimeMillis());
		paymentMapper.savePayment(payment);
		return true;
	}
	
	/**
	 * 获取下一个付款申请单号
	 * @return
	 */
	private String getNextCode() {
		Integer nextNo = paymentMapper.getNextNo();
		if(nextNo == null){
			nextNo = 1;
		}else{
			nextNo++;
		}
		
		String noStr = nextNo.toString();
		
		String paymentNo = "P-" + new SimpleDateFormat("yyyy-MM-dd").format(new Date()) + "-";
		
		for(int i=noStr.length();i<4;i++){
			paymentNo += "0";
		}
		
		paymentNo += noStr;
		return paymentNo;
	}
	
	/**
	 * 更新付款申请单
	 * @param payment
	 * @return
	 * @throws ParseException 
	 */
	public boolean updatePayment(Payment payment) throws ParseException {
		payment.setApplyDate(new SimpleDateFormat("yyyy-MM-dd").parse(payment.getApplyDateStr()).getTime());
		paymentMapper.update(payment);
		return true;
	}
	
	/**
	 * 保存付款申请单
	 * @param paymentId
	 * @param path
	 * @param name
	 * @return
	 */
	public boolean saveShipmentsAtta(String paymentId, String path, String name) {
		paymentAttaMapper.save(paymentId, path, name);
		return true;
	}
	
	/**
	 * 删除付款申请单
	 * @param id
	 * @return
	 */
	public boolean deletePayment(String id) {
		paymentAttaMapper.deleteByPaymentId(id);
		paymentMapper.delete(id);
		return true;
	}
	
	/**
	 * 删除付款申请单附件
	 * @param id
	 * @return
	 */
	public boolean deletePaymentAtta(String id) {
		paymentAttaMapper.delete(id);
		return true;
	}
	
	/**
	 * 提交付款申请单
	 * @param id
	 * @return
	 */
	public boolean submitPayment(String id) {
		paymentMapper.submit(id);
		return true;
	}
	
	/**
	 * 获取付款申请单审批列表
	 * @param param
	 * @return
	 * @throws ParseException 
	 */
	public JSONObject getAuditPayment(PaymentParam param) throws ParseException {
		SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd");
		
		if(param.getSignDateBeginStr() != null && !param.getSignDateBeginStr().trim().equals("")){
			param.setSignDateBegin(fmt.parse(param.getSignDateBeginStr()).getTime());
		}
		
		if(param.getSignDateEndStr() != null && !param.getSignDateEndStr().trim().equals("")){
			param.setSignDateEnd(fmt.parse(param.getSignDateEndStr()).getTime());
		}
		
		if(param.getReceiveDateBeginStr() != null && !param.getReceiveDateBeginStr().trim().equals("")){
			param.setReceiveDateBegin(fmt.parse(param.getReceiveDateBeginStr()).getTime());
		}
		
		if(param.getReceiveDateEndStr() != null && param.getReceiveDateEndStr().trim().equals("")){
			param.setReceiveDateEnd(fmt.parse(param.getReceiveDateEndStr()).getTime());
		}
		
		List<Payment> list = paymentMapper.getAuditList(param);
		int total = paymentMapper.getAuditTotal(param);
		return JSONObject.fromObject(new PageView(total, list));
	}
	
	/**
	 * 获取历史付款申请单
	 * @param id
	 * @return
	 */
	public JSONArray getHisPaymentList(String id) {
		List<Payment> list = paymentMapper.getHisPaymentList(id);
		return JSONArray.fromObject(list);
	}
	
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param status
	 * @param comment
	 * @param user
	 * @return
	 */
	public boolean submitAudit(String id, String option, int status,
			String comment, SysUser user) {
		paymentMapper.submitAudit(id, status);
		Audit audit = new Audit();
		audit.setIoption(Integer.parseInt(option));
		audit.setComment(comment);
		audit.setKey(Integer.parseInt(id));
		audit.setType(Global.AUDIT_TYPE_PAYMENT);
		audit.setUserId(user.getId());
		auditService.saveAudit(audit);
		return true;
	}
	
	/**
	 * 采购订单待付款总数
	 * @return
	 */
	public int getUnPayTotal() {
		return paymentMapper.getUnPayTotal();
	}
	
	/**
	 * 订单被退回总数
	 * @return
	 */
	public int getBackTotal() {
		
		return paymentMapper.getBackTotal();
	}
	
	/**
	 * 获取未审批付款申请单数量
	 * @param seeStatus
	 * @return
	 */
	public int getUnAuditTotal(String seeStatus) {
		PaymentParam param = new PaymentParam();
		param.setAuditStatus(0);
		param.setSeeStatus(seeStatus);
		return paymentMapper.getAuditTotal(param);
	}
	
	/**
	 * 根据ID获取付款申请单
	 * @param id
	 * @return
	 */
	public Payment getPaymentById(String id) {
		
		return paymentMapper.getPaymentById(id);
	}

}
