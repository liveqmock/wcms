package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.procurementplan.entity.ProcurementContract;
import com.kiy.wcms.procurementplan.entity.ProcurementContractParam;

public interface ProcurementContractMapper {
	/**
	 * 获取采购订单列表
	 * @param param
	 * @return
	 */
	List<ProcurementContract> getProcurementContractList(
			ProcurementContractParam param);
	/**
	 * 获取记录总条数
	 * @param param
	 * @return
	 */
	int getTotal(ProcurementContractParam param);
	/**
	 * 获取采购订单编号流水号
	 * @return
	 */
	Integer getNextCode(String prefix);
	/**
	 * 保存采购订单
	 * @param rocurementContract
	 */
	void save(ProcurementContract rocurementContract);
	/**
	 * 更新采购订单
	 * @param rocurementContract
	 */
	void update(ProcurementContract rocurementContract);
	/**
	 * 删除采购订单
	 * @param id
	 */
	void deleteContract(@Param("id")String id);
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param status
	 */
	void submitAudit(@Param("id")String id, @Param("status")int status);
	
	/**
	 * 提交合同
	 * @param id
	 */
	void submitContract(String id);
	
	/**
	 * 获取审批列表
	 * @param param
	 * @return
	 */
	List<ProcurementContract> getAuditList(ProcurementContractParam param);
	
	/**
	 * 获取审批总数
	 * @param param
	 * @return
	 */
	int getAuditTotal(ProcurementContractParam param);
	
	/**
	 * 获取被退回总数
	 * @return
	 */
	int getBackTotal();
}
