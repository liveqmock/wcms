package com.kiy.wcms.design.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.design.entity.DesignAtta;

public interface DesignAttaMapper {
	/**
	 * 保存附件
	 * @param designId
	 * @param path
	 * @param name
	 */
	public void save(@Param("designId")String designId, 
			@Param("path")String path, @Param("name")String name);
	
	/**
	 * 获取附件列表
	 * @param id
	 * @return
	 */
	public List<DesignAtta> getAttaList(String id);
	
	/**
	 * 获取附件路径
	 * @param attaId
	 * @return
	 */
	public String getAttaPath(String attaId);
	
	/**
	 * 删除附件
	 * @param attaId
	 */
	public void delete(String attaId);

}
