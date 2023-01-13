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
    public class AdminPhieuBaoHanhController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminPhieuBaoHanh
        public ActionResult Index()
        {

            var phieuBaoHanhs = db.PhieuBaoHanhs.Include(p => p.PhieuXuat);
            return View(phieuBaoHanhs.ToList());
        }

        // GET: Admin/AdminPhieuBaoHanh/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuBaoHanh phieuBaoHanh = db.PhieuBaoHanhs.Find(id);
            if (phieuBaoHanh == null)
            {
                return HttpNotFound();
            }
            return View(phieuBaoHanh);
        }

        // GET: Admin/AdminPhieuBaoHanh/Create
        public ActionResult Create()
        {
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat");
            return View();
        }

        // POST: Admin/AdminPhieuBaoHanh/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create( PhieuBaoHanh phieuBaoHanh)
        {
            /*if (ModelState.IsValid)
            {
                db.PhieuBaoHanhs.Add(phieuBaoHanh);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "TinhTrang", phieuBaoHanh.MaPhieuXuat);
            return View(phieuBaoHanh);*/
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_TaoPhieuBaoHanh(phieuBaoHanh.MaPhieuXuat, phieuBaoHanh.NgayBatDau, phieuBaoHanh.ThoiGianBaoHanh, phieuBaoHanh.SoKhung, phieuBaoHanh.SoSuon);
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat", phieuBaoHanh.MaPhieuXuat);
            return View(phieuBaoHanh);
        }

        // GET: Admin/AdminPhieuBaoHanh/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuBaoHanh phieuBaoHanh = db.PhieuBaoHanhs.Find(id);
            if (phieuBaoHanh == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat", phieuBaoHanh.MaPhieuXuat);
            return View(phieuBaoHanh);
        }

        // POST: Admin/AdminPhieuBaoHanh/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit( PhieuBaoHanh phieuBaoHanh)
        {
            /*if (ModelState.IsValid)
            {
                db.Entry(phieuBaoHanh).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "TinhTrang", phieuBaoHanh.MaPhieuXuat);
            return View(phieuBaoHanh);*/
            try
            {
                db.sp_CapNhatThongTinPhieuBaoHanh(phieuBaoHanh.MaPhieuBaoHanh,phieuBaoHanh.MaPhieuXuat,phieuBaoHanh.NgayBatDau,phieuBaoHanh.ThoiGianBaoHanh,phieuBaoHanh.SoKhung,phieuBaoHanh.SoSuon);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaPhieuXuat = new SelectList(db.PhieuXuats, "MaPhieuXuat", "MaPhieuXuat", phieuBaoHanh.MaPhieuXuat);
            return View(phieuBaoHanh);
        }

        // GET: Admin/AdminPhieuBaoHanh/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuBaoHanh phieuBaoHanh = db.PhieuBaoHanhs.Find(id);
            if (phieuBaoHanh == null)
            {
                return HttpNotFound();
            }
            return View(phieuBaoHanh);
        }

        // POST: Admin/AdminPhieuBaoHanh/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /*PhieuBaoHanh phieuBaoHanh = db.PhieuBaoHanhs.Find(id);
            db.PhieuBaoHanhs.Remove(phieuBaoHanh);
            db.SaveChanges();
            return RedirectToAction("Index");*/

            try
            {
                db.sp_XoaPhieuBaoHanh(id);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            PhieuBaoHanh phieuBaoHanh = db.PhieuBaoHanhs.Find(id);
            return View(phieuBaoHanh);
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
