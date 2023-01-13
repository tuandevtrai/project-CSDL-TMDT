using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;

namespace XeMayShop.Controllers
{
    public class TimKiemPhieuDatXeController : Controller
    {
        QuanLyXeMayEntities data = new QuanLyXeMayEntities();
        // GET: TimKiemPhieuDatXe
        public ActionResult Index(string SoDienThoai)
        {
            if (string.IsNullOrEmpty(SoDienThoai))
            {
                return View();
            }            
            return View(data.sp_TimKiemPhieuDatXe(SoDienThoai).ToList());
        }

        public ActionResult HuyPhieuDatXe(FormCollection form)
        {

            int id = int.Parse(form["MaPhieuDatXe"].ToString());
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            PhieuDatXe phieuDatXe = data.PhieuDatXes.FirstOrDefault(c => c.MaPhieuDatXe == id);
            if (phieuDatXe == null)
            {
                return HttpNotFound();
            }

            data.sp_XoaPhieuDatXeKhachHang(id);
            return RedirectToAction("Index", "TimKiemPhieuDatXe");

        }
    }
}