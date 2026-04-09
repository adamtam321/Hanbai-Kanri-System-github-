package control;

public class RANKInfo {
	public String 	product_img;	//ランキング商品の画像
	public String	product_name;   //ランキング商品の名前
	public int 	product_Sale;   //ランキング商品の売上
	// 8月　追記
	public int		product_rank;	//ランキング商品の順位:同率順位の判定に使います
	public int		product_AmountSales; // ランキング商品の売上額

	// 8月　追記
	public String 	shop_name;		// ランキング店舗名
	public String 	shop_add; 		// ランキング店舗住所
	public int 	shop_sale; 		// ランキング店舗売上
	public int 	shop_rank;		// ランキング店舗順位:同率順位の判定に使います

	// 商品ステータス判定
	public int newItemJudge; // 1=発売予定, 0=新商品, -1=既存商品



}