package com.kiy.wcms.procurementplan.mapper;

import java.util.List;

import com.kiy.wcms.procurementplan.entity.Accept;
import com.kiy.wcms.procurementplan.entity.AcceptItem;
import com.kiy.wcms.procurementplan.entity.AcceptParam;

public interface AcceptMapper {
	/**
	 * 获取待验收列表
	 * @param param
	 * @return
	 */
	public List<AcceptItem> getAcceptItemList(AcceptParam param);
	
	/**
	 * 获取待验收列表总数
	 * @param param
	 * @return
	 */
	public int getAcceptTotal(AcceptParam param);
	
	/**
	 * 新增验收记录
	 * @param accept
	 */
	public void addAccept(Accept accept);

}
