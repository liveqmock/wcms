package com.kiy.wcms.entrepot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kiy.wcms.entrepot.entity.Entrepot;
import com.kiy.wcms.entrepot.entity.EntrepotTree;

public interface EntrepotMapper {
	/**
	 * 获取仓库列表
	 * @param begin
	 * @param rows
	 * @return
	 */
	public List<Entrepot> getList(@Param("begin")int begin, @Param("rows")Integer rows);
	/**
	 * 获取仓库总数
	 * @return
	 */
	public int getTotal();
	
	/**
	 * 新增仓库
	 * @param entrepot
	 */
	public void addEntrepot(Entrepot entrepot);
	
	/**
	 * 更新仓库
	 * @param entrepot
	 */
	public void update(Entrepot entrepot);
	
	/**
	 * 获取仓库树结构
	 * @return
	 */
	public List<EntrepotTree> getEntrepotTree();

}
