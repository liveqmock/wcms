package com.kiy.wcms.design.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.design.entity.Design;
import com.kiy.wcms.design.entity.DesignParam;

public interface DesignMapper {
	/**
	 * 批量新增设计方案
	 * @param detaiIdList
	 * @param id
	 */
	public void batchSave(@Param("idList")List<Integer> detaiIdList, @Param("id")String id);
	
	/**
	 * 获取设计方案列表
	 * @param param
	 * @return
	 */
	public List<Design> getDesignList(DesignParam param);
	
	/**
	 * 获取总记录条数
	 * @param param
	 * @return
	 */
	public int getTotal(DesignParam param);
	
	/**
	 * 提交设计方案
	 * @param id
	 */
	public void submitDesign(String id);
	
	/**
	 * 获取审批列表
	 * @param param
	 * @return
	 */
	public List<Design> getAuditDesignList(DesignParam param);
	
	/**
	 * 获取审批总数
	 * @param param
	 * @return
	 */
	public int getAuditTotal(DesignParam param);
	
	/**
	 * 提交审批
	 * @param id
	 * @param status
	 */
	public void submitAudit(@Param("id")String id, @Param("status")int status);
	
	/**
	 * 获取被退回总数
	 * @return
	 */
	public int getBackTotal();
	
	/**
	 * 获取未提交总数
	 * @return
	 */
	public int getUnPayTotal();

}
