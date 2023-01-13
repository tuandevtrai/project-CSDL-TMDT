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
    public class AdminNhanVienController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminNhanVien
        public ActionResult Index()
        {
            if (Session["Admin"] == null)
            {
                return RedirectToAction("Index", "AdminLogin");
            }
            else
                return View(db.NhanViens.ToList());
        }

        // GET: Admin/AdminNhanVien/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NhanVien nhanVien = db.NhanViens.Find(id);
            if (nhanVien == null)
            {
                return HttpNotFound();
            }
            return View(nhanVien);
        }

        // GET: Admin/AdminNhanVien/Create
        public ActionResult Create()
        {
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh");
            return View();
        }

        // POST: Admin/AdminNhanVien/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(NhanVien nhanVien)
        {
            /* if (ModelState.IsValid)
             {
                 if (nhanVien.MaChiNhanh == null || nhanVien.TenNhanVien == "" || nhanVien.DienThoai == "")
                 {
                     ViewBag.ErrorInfo = "Sai thông tin tài khoản";
                     return View("Index");

                 }
                 *//*   db.NhanViens.Add(nhanVien);
                    db.SaveChanges();*//*
                 db.sp_ThemNhanVien(nhanVien.TenNhanVien, nhanVien.NamSinh, nhanVien.GioiTinh, nhanVien.DiaChi, nhanVien.DienThoai, nhanVien.MaChiNhanh);
                 ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh");
                 return RedirectToAction("Index");
             }

             return View(nhanVien);*/
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_ThemNhanVien(nhanVien.TenNhanVien, nhanVien.NamSinh, nhanVien.GioiTinh, nhanVien.DiaChi, nhanVien.DienThoai, nhanVien.MaChiNhanh);
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh");
            return View(nhanVien);
        }

        // GET: Admin/AdminNhanVien/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NhanVien nhanVien = db.NhanViens.Find(id);
            if (nhanVien == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh");
            return View(nhanVien);
        }

        // POST: Admin/AdminNhanVien/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit( NhanVien nhanVien)
        {
            /*if (ModelState.IsValid)
            {
                db.Entry(nhanVien).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh");
            return View(nhanVien);*/

            try
            {
                db.sp_ChinhSuaThongTinNhanVien(nhanVien.MaNhanVien,nhanVien.TenNhanVien,nhanVien.NamSinh,nhanVien.GioiTinh,nhanVien.DiaChi,nhanVien.DienThoai,nhanVien.MaChiNhanh);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh");
            return View(nhanVien);
        }

        // GET: Admin/AdminNhanVien/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NhanVien nhanVien = db.NhanViens.Find(id);
            if (nhanVien == null)
            {
                return HttpNotFound();
            }
            return View(nhanVien);

        }

        // POST: Admin/AdminNhanVien/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /*NhanVien nhanVien = db.NhanViens.Find(id);
            db.NhanViens.Remove(nhanVien);
            db.SaveChanges();
            return RedirectToAction("Index");*/
            try
            {
                db.sp_XoaNhanVien(id);
            return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            NhanVien nhanVien = db.NhanViens.Find(id);
            return View(nhanVien);
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
