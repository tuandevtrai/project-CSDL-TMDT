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
    public class AdminChiTietPhieuBaoHanhsController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminChiTietPhieuBaoHanhs
        public ActionResult Index()
        {
            var chiTietPhieuBaoHanhs = db.ChiTietPhieuBaoHanhs.Include(c => c.PhieuBaoHanh);
            return View(chiTietPhieuBaoHanhs.ToList());
        }

        // GET: Admin/AdminChiTietPhieuBaoHanhs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuBaoHanh chiTietPhieuBaoHanh = db.ChiTietPhieuBaoHanhs.Find(id);
            if (chiTietPhieuBaoHanh == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuBaoHanh);
        }

        // GET: Admin/AdminChiTietPhieuBaoHanhs/Create
        public ActionResult Create()
        {
            ViewBag.MaPhieuBaoHanh = new SelectList(db.PhieuBaoHanhs, "MaPhieuBaoHanh", "MaPhieuBaoHanh");
            return View();
        }

        // POST: Admin/AdminChiTietPhieuBaoHanhs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(ChiTietPhieuBaoHanh chiTietPhieuBaoHanh)
        {
            /*if (ModelState.IsValid)
            {
                db.ChiTietPhieuBaoHanhs.Add(chiTietPhieuBaoHanh);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.MaPhieuBaoHanh = new SelectList(db.PhieuBaoHanhs, "MaPhieuBaoHanh", "SoKhung", chiTietPhieuBaoHanh.MaPhieuBaoHanh);
            return View(chiTietPhieuBaoHanh);*/
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_TaoChiTietPhieuBaoHanh(chiTietPhieuBaoHanh.MaPhieuBaoHanh, chiTietPhieuBaoHanh.NgayBaoHanh, chiTietPhieuBaoHanh.GhiChu);
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaPhieuBaoHanh = new SelectList(db.PhieuBaoHanhs, "MaPhieuBaoHanh", "MaPhieuBaoHanh", chiTietPhieuBaoHanh.MaPhieuBaoHanh);
            return View(chiTietPhieuBaoHanh);
        }

        // GET: Admin/AdminChiTietPhieuBaoHanhs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuBaoHanh chiTietPhieuBaoHanh = db.ChiTietPhieuBaoHanhs.Find(id);
            if (chiTietPhieuBaoHanh == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaPhieuBaoHanh = new SelectList(db.PhieuBaoHanhs, "MaPhieuBaoHanh", "MaPhieuBaoHanh", chiTietPhieuBaoHanh.MaPhieuBaoHanh);
            return View(chiTietPhieuBaoHanh);
        }

        // POST: Admin/AdminChiTietPhieuBaoHanhs/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit( ChiTietPhieuBaoHanh chiTietPhieuBaoHanh)
        {
            /* if (ModelState.IsValid)
             {
                 db.Entry(chiTietPhieuBaoHanh).State = EntityState.Modified;
                 db.SaveChanges();
                 return RedirectToAction("Index");
             }
             ViewBag.MaPhieuBaoHanh = new SelectList(db.PhieuBaoHanhs, "MaPhieuBaoHanh", "SoKhung", chiTietPhieuBaoHanh.MaPhieuBaoHanh);
             return View(chiTietPhieuBaoHanh);*/
            try
            {
                db.sp_CapNhatThongTinChiTietPhieuBaoHanh(chiTietPhieuBaoHanh.MaChiTietPhieuBaoHanh,chiTietPhieuBaoHanh.MaPhieuBaoHanh,chiTietPhieuBaoHanh.NgayBaoHanh,chiTietPhieuBaoHanh.GhiChu);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            return View(chiTietPhieuBaoHanh);
        }

        // GET: Admin/AdminChiTietPhieuBaoHanhs/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuBaoHanh chiTietPhieuBaoHanh = db.ChiTietPhieuBaoHanhs.Find(id);
            if (chiTietPhieuBaoHanh == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuBaoHanh);
        }

        // POST: Admin/AdminChiTietPhieuBaoHanhs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /* ChiTietPhieuBaoHanh chiTietPhieuBaoHanh = db.ChiTietPhieuBaoHanhs.Find(id);
             db.ChiTietPhieuBaoHanhs.Remove(chiTietPhieuBaoHanh);
             db.SaveChanges();
             return RedirectToAction("Index");*/

            try
            {
                db.sp_XoaChiTietPhieuBaoHanh(id);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ChiTietPhieuBaoHanh chiTietPhieuBaoHanh = db.ChiTietPhieuBaoHanhs.Find(id);
            return View(chiTietPhieuBaoHanh);
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
