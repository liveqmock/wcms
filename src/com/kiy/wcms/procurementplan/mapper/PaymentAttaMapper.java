package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.procurementplan.entity.PaymentAtta;

public interface PaymentAttaMapper {
	/**
	 * 获取付款申请单附件列表
	 * @param paymentId
	 * @return
	 */
	public List<PaymentAtta> getList(String paymentId);
	
	/**
	 * 获取附件路径
	 * @param id
	 * @return
	 */
	public String getPath(String id);
	
	/**
	 * 保存付款申请单
	 * @param paymentId
	 * @param path
	 * @param name
	 */
	public void save(@Param("paymentId")String paymentId, @Param("path")String path, @Param("name")String name);
	
	/**
	 * 删除付款申请单附件
	 * @param id
	 */
	public void delete(String id);
	
	/**
	 * 根据付款申请单ID删除附件
	 * @param id
	 */
	public void deleteByPaymentId(String id);

}
