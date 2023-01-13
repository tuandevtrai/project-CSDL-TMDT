using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;
using PagedList;
namespace XeMayShop.Controllers
{
    public class ShopController : Controller
    {
        QuanLyXeMayEntities data = new QuanLyXeMayEntities();
        // GET: Shop
        public ActionResult Index(string MaXe, string TenDongXe, string TenXe, int page = 1, int pagelist = 6)
        {
            ViewBag.XeTayCon = data.DongXes.Where(x => x.MaLoaiXe == 3).ToList();
            ViewBag.XeTayGa = data.DongXes.Where(x => x.MaLoaiXe == 2).ToList();
            ViewBag.XeSo = data.DongXes.Where(x => x.MaLoaiXe == 1).ToList();            


            if (MaXe != null)
            {
                int a = int.Parse(MaXe.ToString());
                ViewBag.MatHangTheoTheLoai = data.Xes.Where(c => c.MaXe == a).ToList();
                return View(data.Xes.Where(c => c.MaXe == a).ToList().OrderByDescending(c => c.TenXe).ToPagedList(page, pagelist));
            }
            else
           if (TenXe != null)
            {
                return View(data.Xes.Where(c => c.TenXe.ToLower().Contains(TenXe.ToLower())).OrderByDescending(c => c.TenXe).ToPagedList(page, pagelist));
            }
            else 
            if(TenDongXe != null)
            {
                return View(data.Xes.OrderByDescending(x => x.TenXe).Where(s => s.DongXe.TenDongXe == TenDongXe).ToPagedList(page, pagelist));                
            }

            return View(data.Xes.OrderByDescending(x => x.TenXe).ToPagedList(page, pagelist));

            
        }
    }
}