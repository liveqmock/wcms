package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.order.entity.OrderAtta;

public interface ProcurementAttaMapper {
	/**
	 * 保存采购计划附件
	 * @param planId
	 * @param path
	 */
	public void save(@Param("planId")String planId, @Param("path")String path, @Param("fileName")String fileName);
	/**
	 * 获取采购计划附件列表
	 * @param planId
	 * @return
	 */
	public List<OrderAtta> getAll(String planId);
	/**
	 * 删除采购计划附件
	 * @param attaId
	 */
	public void delete(String attaId);
	/**
	 * 获取采购计划路径
	 * @param attaId
	 * @return
	 */
	public String getAttaPath(String attaId);
	/**
	 * 删除指定采购计划的所有附件
	 * @param planid
	 */
	public void deleteByPlanId(String planid);
}
