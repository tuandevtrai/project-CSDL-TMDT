using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;

namespace XeMayShop.Controllers
{
    public class DatXeController : Controller
    {
        QuanLyXeMayEntities data = new QuanLyXeMayEntities();
        // GET: DatXe

        
        public ActionResult DatXe(int id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Xe xe = data.Xes.Find(id);
            if (xe == null)
            {
                return RedirectToAction("Index", "Home");
            }
            Session["Xe"] = xe;
            return View(xe);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult HoanThanhDatXe(FormCollection form)
        {
            Xe xe = Session["Xe"] as Xe;
            if (xe == null)
            {
                return RedirectToAction("Index", "Home");
            }

            string tenKH = form["TenKH"];            
            string SDT = form["SDT"];

            if (tenKH == "" || SDT == "")
            {
                ViewBag.ErrorInfo = "Vui lòng nhập hết thông tin";               
                return View("DatXe");
            }
            data.sp_TaoPhieuDatXe(xe.MaXe,xe.MauXe,tenKH,SDT);


            return RedirectToAction("DatHangThanhCong", "ThongBao");
        }

    }
}