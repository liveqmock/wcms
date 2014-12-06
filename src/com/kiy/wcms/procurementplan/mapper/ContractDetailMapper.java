package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.procurementplan.entity.ContractDetail;

public interface ContractDetailMapper {
	/**
	 * 采购订单明细列表查询
	 * @param contractId
	 * @return
	 */
	List<ContractDetail> getDetailList(@Param("contractId")String contractId);
	/**
	 * 保存采购订单明细信息
	 * @param contractDetail
	 */
	void saveDetail(ContractDetail contractDetail);
	/**
	 * 更新采购订单明细信息
	 * @param contractDetail
	 */
	void updateDetail(ContractDetail contractDetail);
	/**
	 * 删除采购订单明细信息
	 * @param id
	 */
	void deleteDetail(@Param("id")String id);
	/**
	 * 通过采购订单ID删除采购订单明细信息
	 * @param contractId
	 */
	void deleteContractDetailByContractId(@Param("contractId")String contractId);
}
