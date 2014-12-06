package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.procurementplan.entity.Contract;
import com.kiy.wcms.procurementplan.entity.Payment;
import com.kiy.wcms.procurementplan.entity.PaymentParam;

public interface PaymentMapper {
	/**
	 * 获取已生效的合同列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public List<Contract> getContractList(@Param("begin")int begin, @Param("rows")Integer rows);
	
	/**
	 * 获取已生效合同总数
	 * @return
	 */
	public int getContractTotal();
	
	/**
	 * 获取付款申请单列表
	 * @param contractId
	 * @return
	 */
	public List<Payment> getPaymentList(String contractId);
	
	/**
	 * 保存付款申请单
	 * @param payment
	 */
	public void savePayment(Payment payment);
	
	/**
	 * 获取下一个流水号
	 * @return
	 */
	public Integer getNextNo();
	
	/**
	 * 更新付款申请单
	 * @param payment
	 */
	public void update(Payment payment);
	
	/**
	 * 删除付款申请单
	 * @param id
	 */
	public void delete(String id);
	
	/**
	 * 提交付款申请单
	 * @param id
	 */
	public void submit(String id);
	
	/**
	 * 获取付款申请单审批列表
	 * @param param
	 * @return
	 */
	public List<Payment> getAuditList(PaymentParam param);
	
	/**
	 * 获取付款申请单总数
	 * @param param
	 * @return
	 */
	public int getAuditTotal(PaymentParam param);
	
	/**
	 * 获取历史付款申请单
	 * @param id
	 * @return
	 */
	public List<Payment> getHisPaymentList(String id);
	
	/**
	 * 提交审批
	 * @param id
	 * @param status
	 */
	public void submitAudit(@Param("id")String id, @Param("status")int status);
	
	/**
	 * 获取待付款总数
	 * @return
	 */
	public int getUnPayTotal();
	
	/**
	 * 获取被退回总数
	 * @return
	 */
	public int getBackTotal();
	
	/**
	 * 根据ID获取付款申请单
	 * @param id
	 * @return
	 */
	public Payment getPaymentById(String id);

}
