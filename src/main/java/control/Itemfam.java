package control;

import java.sql.Date;

public class Itemfam {
	public String ItemId;
	public String ItemName;
	public String uriItemName;
	public String maker;
	public String genre;
	public Date day;
	public int price;
	public String img;
	// 8月　新商品判定 -1:既存品 0:新商品 1:発売予定
	public int newItemJudge;

}