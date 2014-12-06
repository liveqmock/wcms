package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.procurementplan.entity.ContractAtta;


public interface ContractAttaMapper {
	/**
	 * 保存采购计划附件
	 * @param contractId
	 * @param filePath
	 */
	public void save(@Param("contractId")String contractId, @Param("filePath")String filePath, @Param("fileName")String fileName);
	/**
	 * 获取采购计划附件列表
	 * @param contractId
	 * @return
	 */
	public List<ContractAtta> getAll(String contractId);
	/**
	 * 删除采购计划附件
	 * @param id
	 */
	public void delete(String id);
	/**
	 * 获取采购计划路径
	 * @param id
	 * @return
	 */
	public String getAttaPath(String id);
	/**
	 * 通过采购订单ID删除附件
	 * @param contractId
	 */
	public void deleteAttaByContractId(@Param("contractId")String contractId);
}
