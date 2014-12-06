package com.kiy.wcms.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.jxls.exception.ParsePropertyException;
import net.sf.jxls.transformer.XLSTransformer;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Workbook;

/**
 * 操作导出Excel
 * 
 * @author kiy
 * @since 2014/11/4
 */
public class ExportExcel {
	protected final static Log logger = LogFactory.getLog(ExportExcel.class);

	/**
	 * 根据模板生成文件到指定路径
	 * 
	 * @param srcPath
	 * @param desPath
	 * @param desName
	 * @param datas
	 * @return
	 */
	public static boolean reportExcelSave(String srcPath, String desPath,
			String desName, Map datas) {
		boolean flag = false;
		XLSTransformer transformer = new XLSTransformer();
		File xlsDir = new File(desPath);
		if (!xlsDir.exists()) {
			xlsDir.mkdirs();
		}
		try {
			transformer.transformXLS(srcPath, datas, desPath + desName);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("生成Excel文件出错" + e.getMessage());
		} finally {
			System.gc();// 垃圾回收
		}
		return flag;
	}

	/**
	 * 通过模板输入流生成文件
	 * 
	 * @param in
	 * @param targetMap
	 * @param targetUrl
	 * @return
	 */
	public boolean createFileByInputStream(InputStream in, Map targetMap,
			String targetUrl) {
		boolean flag = false;
		XLSTransformer transformer = new XLSTransformer();
		Workbook workBook = null;
		OutputStream out = null;
		try {
			File desFile = new File(targetUrl);
			out = new FileOutputStream(desFile);
			workBook = transformer.transformXLS(in, targetMap);
			workBook.write(out);
			flag = true;
		} catch (ParsePropertyException e) {
			e.printStackTrace();
			logger.error("function createFileByInputStream(" + targetUrl
					+ ") error:" + e.getMessage());
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			logger.error("function createFileByInputStream(" + targetUrl
					+ ") error:" + e.getMessage());
		} catch (IOException e) {
			e.printStackTrace();
			logger.error("function createFileByInputStream(" + targetUrl
					+ ") error:" + e.getMessage());
		} catch (InvalidFormatException e) {
			e.printStackTrace();
		}  finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (out != null) {
				try {
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return flag;
	}
	/**
	 * 生成Excel到数据流中
	 * 
	 * @param srcPath
	 *            模板文件路径
	 * @param targetName
	 *            要生成的Excel名称
	 * @param response
	 *            HttpServletResponse对象
	 * @param targetMap
	 *            封装要显示的数据
	 * @return 是否成功
	 */
	public boolean exportToStream(String srcPath, String targetName,
			HttpServletResponse response, Map targetMap) {
		InputStream is = null;
		Workbook workBook = null;
		try {
			targetName = new String(targetName.getBytes("GBK"), "ISO8859_1");
		} catch (UnsupportedEncodingException e1) {
			e1.printStackTrace();
		}
		
		try {
			is=new FileInputStream(srcPath);
			XLSTransformer transformer = new XLSTransformer();
			// 关联模板
			workBook = transformer.transformXLS(is, targetMap);
			// 输出excel
			saveWorkbook(workBook, response, targetName);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error("function exportToStream(" + srcPath + ") error:"
					+ e.getMessage());
			return false;
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return true;
	}
	/**
	 * 输出Excel
	 * 
	 * @param workBook
	 *            HSSFWorkbook对象
	 * @param response
	 *            HttpServletResponse对象
	 * @param targetName
	 *            生成的目标文件名称
	 */
	private void saveWorkbook(Workbook workBook, HttpServletResponse response,
			String targetName) {
		OutputStream os = null;
		try {
			response.reset(); // 非常重要
			response.setHeader("content-disposition", "attachment; filename="
					+ targetName);
			response.setContentType("application/msexcel");
			os = response.getOutputStream();
			if(os!=null)
			{
			  workBook.write(os);
			}

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			//e.printStackTrace();
			logger.error("function saveWorkbook error:"+e.getMessage());
		} finally {
			try {
				if (os != null) {
					os.flush();
					os.close();
				}
			} catch (IOException e) {
				//e.printStackTrace();
			}

		}

	}
}

