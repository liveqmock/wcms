package com.kiy.wcms.gather.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.gather.entity.GatherAtta;

public interface GatherAttaMapper {
	/**
	 * 保存收款单附件信息
	 * @param gatherId
	 * @param path
	 * @param name
	 */
	public void saveGatherAtta(@Param("gatherId")String gatherId, 
			@Param("path")String path, @Param("name")String name);
	
	/**
	 * 获取收款单附件列表
	 * @param id
	 * @return
	 */
	public List<GatherAtta> getGatherAttaList(String id);
	
	/**
	 * 获取附件路径
	 * @param id
	 * @return
	 */
	public String getAttaPath(String id);
	
	/**
	 * 删除收款单附件
	 * @param id
	 */
	public void deleteGatherAtta(String id);

}
