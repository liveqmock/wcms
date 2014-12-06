package com.kiy.wcms.entrepot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kiy.wcms.entrepot.entity.Stock;
import com.kiy.wcms.entrepot.mapper.StockMapper;

@Transactional
@Service("EntrepotOptionsService")
@Scope("singleton")
public class EntrepotOptionsService {
	private static String lock = "lock";
	@Autowired
	private StockMapper stockMapper;
	
	/**
	 * 库存操作
	 * @param goodsId     物品ID
	 * @param entrepotId  仓库ID
	 * @param shelfId     货架ID
	 * @param amount      数量
	 * @param type        0:入库    1:出库
	 * @return  是否操作成功
	 */
	public boolean entrepotOption(int goodsId, int entrepotId, int shelfId, double amount, int type){
		synchronized (lock) {
			boolean flag = false;
			//1.根据物品信息 获取 库存数
			double total = stockMapper.getGoodsTotal(goodsId, entrepotId, shelfId);
			
			Stock stock = new Stock();
			stock.setGoodsId(goodsId);
			stock.setEntrepotId(entrepotId);
			stock.setShelfId(shelfId);
			
			switch(type){
				case 0://入库
					//如果库存为0， 则新增一条库存记录
					if(total == 0){
						stock.setQuantity(amount);
						stockMapper.save(stock);
					}else{//如果库存不为0,则进行累加操作
						stock.setQuantity(total + amount);
						stockMapper.update(stock);
					}
					flag = true;
					break;
				case 1://出库
					//如果库存量比要求出货量多则取消操作， 否则减少库存
					if(total >= amount){
						stock.setQuantity(total - amount);
						stockMapper.update(stock);
						flag = true;
					}
					break;
			}
			return flag;
		}
	}
}
