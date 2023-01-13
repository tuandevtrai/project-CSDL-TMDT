using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;

namespace XeMayShop.Controllers
{
    public class ThongBaoController : Controller
    {
        QuanLyXeMayEntities data = new QuanLyXeMayEntities();
        // GET: ThongBao
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult DatHangThanhCong()
        {
            return View();
        }

        public ActionResult TimKiemDonDatHang(string SoDienThoai)
        {
            if (SoDienThoai == null)
                return View();
            List<PhieuDatXe> listPhieuDatXe = data.PhieuDatXes.Where(c => c.SDT == SoDienThoai).ToList();
            return View(listPhieuDatXe);
            
        }

    }
}