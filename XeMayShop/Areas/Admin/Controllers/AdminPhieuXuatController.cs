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
    public class AdminPhieuXuatController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminPhieuXuat
        public ActionResult Index()
        {
            if (Session["Admin"] == null)
            {
                return RedirectToAction("Index", "AdminLogin");
            }
            else
            {
                var phieuXuats = db.PhieuXuats.Include(p => p.KhachHang).Include(p => p.NhanVien);
                return View(phieuXuats.ToList());
            }
        }

        // GET: Admin/AdminPhieuXuat/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            if (phieuXuat == null)
            {
                return HttpNotFound();
            }
            return View(phieuXuat);
        }

        // GET: Admin/AdminPhieuXuat/Create
        public ActionResult Create()
        {
            ViewBag.MaKhachHang = new SelectList(db.KhachHangs, "MaKhachHang", "TenKhachHang");
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh");
            ViewBag.MaNhanVien = new SelectList(db.NhanViens, "MaNhanVien", "TenNhanVien");
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe");
            return View();
        }

        // POST: Admin/AdminPhieuXuat/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(PhieuXuat phieuXuat)
        {
            if (ModelState.IsValid)
            {
                /*db.PhieuXuats.Add(phieuXuat);
                db.SaveChanges();
                return RedirectToAction("Index");*/


                db.sp_TaoPhieuXuat(phieuXuat.MaNhanVien, phieuXuat.MaKhachHang, phieuXuat.MaChiNhanh, phieuXuat.MaXe, phieuXuat.MauXe, phieuXuat.ThanhTienXuat,phieuXuat.GhiChu);
                return RedirectToAction("Index");
            }

            ViewBag.MaKhachHang = new SelectList(db.KhachHangs, "MaKhachHang", "TenKhachHang", phieuXuat.MaKhachHang);
            ViewBag.MaNhanVien = new SelectList(db.NhanViens, "MaNhanVien", "TenNhanVien", phieuXuat.MaNhanVien);
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh",phieuXuat.MaChiNhanh);
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe",phieuXuat.MaXe);
            return View(phieuXuat);
        }

        // GET: Admin/AdminPhieuXuat/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            if (phieuXuat == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaKhachHang = new SelectList(db.KhachHangs, "MaKhachHang", "TenKhachHang", phieuXuat.MaKhachHang);
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh", phieuXuat.MaChiNhanh);
            ViewBag.MaNhanVien = new SelectList(db.NhanViens, "MaNhanVien", "TenNhanVien", phieuXuat.MaNhanVien);
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", phieuXuat.MaXe);
            return View(phieuXuat);
        }

        // POST: Admin/AdminPhieuXuat/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(PhieuXuat phieuXuat)
        {
            /*if (ModelState.IsValid)
            {
                db.Entry(phieuXuat).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaKhachHang = new SelectList(db.KhachHangs, "MaKhachHang", "TenKhachHang", phieuXuat.MaKhachHang);
            ViewBag.MaNhanVien = new SelectList(db.NhanViens, "MaNhanVien", "TenNhanVien", phieuXuat.MaNhanVien);
            return View(phieuXuat);*/
            try
            {
                db.sp_CapNhatThongTinPhieuXuat(phieuXuat.MaPhieuXuat, phieuXuat.MaNhanVien, phieuXuat.MaKhachHang, phieuXuat.MaChiNhanh, phieuXuat.MaXe, phieuXuat.MauXe, phieuXuat.NgayXuat, phieuXuat.ThanhTienXuat, phieuXuat.GhiChu);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaKhachHang = new SelectList(db.KhachHangs, "MaKhachHang", "TenKhachHang", phieuXuat.MaKhachHang);
            ViewBag.MaChiNhanh = new SelectList(db.ChiNhanhs, "MaChiNhanh", "TenChiNhanh", phieuXuat.MaChiNhanh);
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", phieuXuat.MaXe);
            ViewBag.MaNhanVien = new SelectList(db.NhanViens, "MaNhanVien", "TenNhanVien", phieuXuat.MaNhanVien);
            return View(phieuXuat);
        }

        // GET: Admin/AdminPhieuXuat/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            if (phieuXuat == null)
            {
                return HttpNotFound();
            }
            return View(phieuXuat);
        }

        // POST: Admin/AdminPhieuXuat/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /* PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
             db.PhieuXuats.Remove(phieuXuat);
             db.SaveChanges();
             return RedirectToAction("Index");*/
            try
            {
                db.sp_XoaThongTinPhieuXuat(id);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            PhieuXuat phieuXuat = db.PhieuXuats.Find(id);
            return View(phieuXuat);
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
