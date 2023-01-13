using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using XeMayShop.Models;

namespace XeMayShop.Areas.Admin.Controllers
{
    public class AdminNhaCungCapController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminNhaCungCap
        public ActionResult Index()
        {
            if (Session["Admin"] == null)
            {
                return RedirectToAction("Index", "AdminLogin");
            }
            else
                return View(db.NhaCungCaps.ToList());
        }

        // GET: Admin/AdminNhaCungCap/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NhaCungCap nhaCungCap = db.NhaCungCaps.Find(id);
            if (nhaCungCap == null)
            {
                return HttpNotFound();
            }
            return View(nhaCungCap);
        }

        // GET: Admin/AdminNhaCungCap/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/AdminNhaCungCap/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(NhaCungCap nhaCungCap)
        {
            /*if (ModelState.IsValid)
            {
                if(nhaCungCap.TenNhaCungCap == null || nhaCungCap.TenNhaCungCap == "" || nhaCungCap.DienThoai == null || nhaCungCap.DienThoai == "")
                {
                    ViewBag.ErrorInfo = "Yêu cầu nhập thông tin đầy đủ";
                    return View("Create");
                }

                *//*db.NhaCungCaps.Add(nhaCungCap);
                db.SaveChanges();*//*
                db.sp_TaoNhaCungCap(nhaCungCap.TenNhaCungCap, nhaCungCap.DiaChi, nhaCungCap.DienThoai, nhaCungCap.Email);

                return RedirectToAction("Index");
            }

            return View(nhaCungCap);*/
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_TaoNhaCungCap(nhaCungCap.TenNhaCungCap, nhaCungCap.DiaChi, nhaCungCap.DienThoai, nhaCungCap.Email);
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            return View(nhaCungCap);
        }

        // GET: Admin/AdminNhaCungCap/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NhaCungCap nhaCungCap = db.NhaCungCaps.Find(id);
            if (nhaCungCap == null)
            {
                return HttpNotFound();
            }
            return View(nhaCungCap);
        }

        // POST: Admin/AdminNhaCungCap/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(NhaCungCap nhaCungCap)
        {            
            
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_ChinhSuaThongTinNhaCungCap(nhaCungCap.MaNhaCungCap, nhaCungCap.TenNhaCungCap, nhaCungCap.DiaChi, nhaCungCap.DienThoai, nhaCungCap.Email);
                    return RedirectToAction("Index");
                }
                
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            return View(nhaCungCap);
        }

        // GET: Admin/AdminNhaCungCap/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NhaCungCap nhaCungCap = db.NhaCungCaps.Find(id);
            if (nhaCungCap == null)
            {
                return HttpNotFound();
            }
            return View(nhaCungCap);
        }

        // POST: Admin/AdminNhaCungCap/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /* NhaCungCap nhaCungCap = db.NhaCungCaps.Find(id);
             db.NhaCungCaps.Remove(nhaCungCap);
             db.SaveChanges();
             return RedirectToAction("Index");*/
            try
            {
                db.sp_XoaNhaCungCap(id);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            NhaCungCap nhanCunCap = db.NhaCungCaps.Find(id);
            return View(nhanCunCap);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
