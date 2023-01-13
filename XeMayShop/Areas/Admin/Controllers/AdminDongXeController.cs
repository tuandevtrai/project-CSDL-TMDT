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
    public class AdminDongXeController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminDongXe
        public ActionResult Index()
        {
            if (Session["Admin"] == null)
            {
                return RedirectToAction("Index", "AdminLogin");
            }
            else
                return View(db.DongXes.ToList());
        }

        // GET: Admin/AdminDongXe/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DongXe dongXe = db.DongXes.Find(id);
            if (dongXe == null)
            {
                return HttpNotFound();
            }
            return View(dongXe);
        }

        // GET: Admin/AdminDongXe/Create
        public ActionResult Create()
        {
            ViewBag.MaLoaiXe = new SelectList(db.LoaiXes, "MaLoaiXe", "TenLoaiXe");
            return View();
        }

        // POST: Admin/AdminDongXe/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(DongXe dongXe)
        {
            /*if (ModelState.IsValid)
            {
                db.DongXes.Add(dongXe);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(dongXe);*/
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_ThemDongXeMoi(dongXe.MaLoaiXe, dongXe.TenDongXe);
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.Message;
            }
            ViewBag.MaLoaiXe = new SelectList(db.LoaiXes, "MaLoaiXe", "TenLoaiXe");
            return View();

        }

        // GET: Admin/AdminDongXe/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DongXe dongXe = db.DongXes.Find(id);
            if (dongXe == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaLoaiXe = new SelectList(db.LoaiXes, "MaLoaiXe", "TenLoaiXe");
            return View(dongXe);


        }

        // POST: Admin/AdminDongXe/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(DongXe dongXe)
        {
            /*if (ModelState.IsValid)
            {
                db.Entry(dongXe).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(dongXe);*/
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_CapNhatThongTinDongXe(dongXe.MaDongXe, dongXe.MaLoaiXe, dongXe.TenDongXe);
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.Message;
            }
            ViewBag.MaLoaiXe = new SelectList(db.LoaiXes, "MaLoaiXe", "TenLoaiXe");
            return View(dongXe);
        }

        // GET: Admin/AdminDongXe/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DongXe dongXe = db.DongXes.Find(id);
            if (dongXe == null)
            {
                return HttpNotFound();
            }
            return View(dongXe);
        }

        // POST: Admin/AdminDongXe/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                db.sp_XoaDongXe(id);
                return RedirectToAction("Index");
                
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.Message;
            }
            return View(db.DongXes.Find(id));

            /*DongXe dongXe = db.DongXes.Find(id);
            db.DongXes.Remove(dongXe);
            db.SaveChanges();
            return RedirectToAction("Index");*/
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
