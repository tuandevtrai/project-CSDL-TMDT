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
    public class AdminLoaiXeController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminLoaiXe
        public ActionResult Index()
        {
            if (Session["Admin"] == null)
            {
                return RedirectToAction("Index", "AdminLogin");
            }
            else
                return View(db.LoaiXes.ToList());
        }

        // GET: Admin/AdminLoaiXe/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LoaiXe loaiXe = db.LoaiXes.Find(id);
            if (loaiXe == null)
            {
                return HttpNotFound();
            }
            return View(loaiXe);
        }

        // GET: Admin/AdminLoaiXe/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/AdminLoaiXe/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(LoaiXe loaiXe)
        {
            /*if (ModelState.IsValid)
            {
                db.LoaiXes.Add(loaiXe);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(loaiXe);*/

            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_ThemLoaiXeMoi(loaiXe.TenLoaiXe);
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.Message;
            }
            return View(loaiXe);
        }

        // GET: Admin/AdminLoaiXe/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LoaiXe loaiXe = db.LoaiXes.Find(id);
            if (loaiXe == null)
            {
                return HttpNotFound();
            }
            return View(loaiXe);
        }

        // POST: Admin/AdminLoaiXe/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit( LoaiXe loaiXe)
        {
            /*if (ModelState.IsValid)
            {
                db.Entry(loaiXe).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(loaiXe);*/

            try
            {
                db.sp_CapNhatThongTinLoaiXe(loaiXe.MaLoaiXe, loaiXe.TenLoaiXe);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.Message;
            }
            return View(loaiXe);


        }

        // GET: Admin/AdminLoaiXe/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LoaiXe loaiXe = db.LoaiXes.Find(id);
            if (loaiXe == null)
            {
                return HttpNotFound();
            }
            return View(loaiXe);
        }

        // POST: Admin/AdminLoaiXe/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            /*LoaiXe loaiXe = db.LoaiXes.Find(id);
            db.LoaiXes.Remove(loaiXe);
            db.SaveChanges();
            return RedirectToAction("Index");*/

            try
            {
                db.sp_XoaLoaiXe(id);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.Message;
            }
            LoaiXe loaiXe = db.LoaiXes.Find(id);
            return View(loaiXe);
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
