package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import com.kiy.wcms.procurementplan.entity.ContractDetail;
import com.kiy.wcms.procurementplan.entity.ProcurementDetail;
import com.kiy.wcms.procurementplan.entity.ProcurementDetailParam;

public interface ProcurementDetailMapper {
	/**
	 * 获取采购计划明细信息
	 * @param planId
	 */
	List<ProcurementDetail> getProcurementDetailList(String planId);
	/**
	 * 保存采购计划明细信息
	 * @param procurementDetail
	 */
	void saveProcurementDetail(ProcurementDetail procurementDetail);
	/**
	 * 修改采购计划明细信息
	 * @param procurementDetail
	 */
	void updateProcurementDetail(ProcurementDetail procurementDetail);
//	/**
//	 * 获取物品库信息
//	 */
//	List<ProcurementDetailParam> addProcurementDetailList();
	/**
	 * 删除采购计划明细信息
	 * @param detailId
	 */
	void deleteProcurementDetail(String detailId);
	/**
	 * 通过计划ID删除计划明细信息
	 * @param planId
	 */
	void deleteProcurementDetailByPlanId(String planId);
	/**
	 * 通过条件获取采购计划明细信息
	 * @param procurementDetailParam
	 */
	List<ProcurementDetailParam> getPlanListByCondition(
			ProcurementDetailParam procurementDetailParam);
	/**
	 * 通过条件获取采购计划明细信息总数
	 * @param procurementDetailParam
	 */
	int getPlanDetailListTotal(ProcurementDetailParam procurementDetailParam);
	
	/**
	 * 添加采购计划明细
	 * @param contractDetail
	 * @return
	 */
	void saveDetail(ContractDetail contractDetail);
	
}
