package com.kiy.wcms.sys.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.sys.entity.Audit;

public interface AuditMapper {
	/**
	 * 获取审批记录列表
	 * @param id
	 * @param type
	 * @return
	 */
	public List<Audit> getAuditList(@Param("id")String id, @Param("type")String type);
	
	/**
	 * 保存审批记录
	 * @param audit
	 */
	public void save(Audit audit);

}
