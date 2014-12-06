package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.procurementplan.entity.ProcurementPlan;
import com.kiy.wcms.procurementplan.entity.ProcurementPlanParam;

public interface ProcurementPlanMapper {
	/**
	 * 获取记录总条数
	 * @param param
	 * @return
	 */
	int getTotal(ProcurementPlanParam param);
	/**
	 * 获取采购计划列表
	 * @param param
	 * @return
	 */
	List<ProcurementPlan> getProcurementPlanList(
			ProcurementPlanParam param);
	/**
	 * 保存采购计划
	 * @param procurementPlan
	 */
	void save(ProcurementPlan procurementPlan);
	/**
	 * 获取采购计划编号流水号
	 * @return
	 */
	Integer getNextCode();
	/**
	 * 更新采购计划
	 * @param procurementPlan
	 */
	void updateProcurementPlan(ProcurementPlan procurementPlan);
	/**
	 * 删除采购计划
	 * @param id
	 */
	void deleteProcurementPlan(String id);
	/**
	 * 提交审批
	 * @param id
	 * @param option
	 * @param status
	 */
	void submitAudit(@Param("id")String id, @Param("status")int status);
	/**
	 * 提交采购计划
	 * @param id
	 */
	void submitPlan(String id);
	
	List<ProcurementPlan> getAuditPlanList(
			ProcurementPlanParam procurementPlanParam);
	
	int getAuditTotal(ProcurementPlanParam procurementPlanParam);
	/**
	 * 获取被退回总数
	 * @return
	 */
	int getBackTotal();
}
