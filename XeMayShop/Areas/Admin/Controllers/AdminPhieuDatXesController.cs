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
    public class AdminPhieuDatXesController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminPhieuDatXes
        public ActionResult Index()
        {
            var phieuDatXes = db.PhieuDatXes.Include(p => p.Xe);
            return View(phieuDatXes.ToList());
        }

        // GET: Admin/AdminPhieuDatXes/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuDatXe phieuDatXe = db.PhieuDatXes.Find(id);
            if (phieuDatXe == null)
            {
                return HttpNotFound();
            }
            return View(phieuDatXe);
        }

     

        // GET: Admin/AdminPhieuDatXes/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuDatXe phieuDatXe = db.PhieuDatXes.Find(id);
            if (phieuDatXe == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", phieuDatXe.MaXe);
            return View(phieuDatXe);
        }

        // POST: Admin/AdminPhieuDatXes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(PhieuDatXe phieuDatXe)
        {
            /*if (ModelState.IsValid)
            {
                db.Entry(phieuDatXe).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "MauXe", phieuDatXe.MaXe);
            return View(phieuDatXe);*/
            try
            {
                db.sp_CapNhatThongTinPhieuDatXe(phieuDatXe.MaPhieuDatXe,phieuDatXe.MaXe,phieuDatXe.MauXe,phieuDatXe.TenNguoiDat,phieuDatXe.SDT,phieuDatXe.TinhTrang,phieuDatXe.NgayDat);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", phieuDatXe.MaXe);
            return View(phieuDatXe);
        }

        // GET: Admin/AdminPhieuDatXes/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            PhieuDatXe phieuDatXe = db.PhieuDatXes.Find(id);
            if (phieuDatXe == null)
            {
                return HttpNotFound();
            }
            return View(phieuDatXe);
        }

        // POST: Admin/AdminPhieuDatXes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /*PhieuDatXe phieuDatXe = db.PhieuDatXes.Find(id);
            db.PhieuDatXes.Remove(phieuDatXe);
            db.SaveChanges();
            return RedirectToAction("Index");*/
            try
            {
                db.sp_XoaChiNhanh(id);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            PhieuDatXe phieuDatXe = db.PhieuDatXes.Find(id);
            return View(phieuDatXe);
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
