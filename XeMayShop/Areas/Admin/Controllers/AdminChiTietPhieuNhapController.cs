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
    public class AdminChiTietPhieuNhapController : Controller
    {
        private QuanLyXeMayEntities db = new QuanLyXeMayEntities();

        // GET: Admin/AdminChiTietPhieuNhap
        public ActionResult Index(string MaPhieuNhap)
        {
            if (Session["Admin"] == null)
            {
                return RedirectToAction("Index", "AdminLogin");
            }
            if(MaPhieuNhap == "" || MaPhieuNhap == null)
            {
                var chiTietPhieuNhaps = db.ChiTietPhieuNhaps.Include(c => c.PhieuNhap).Include(c => c.Xe);
                return View(chiTietPhieuNhaps.ToList());
            }
            else
            {
                int id = int.Parse(MaPhieuNhap);
                var chiTietPhieuNhaps = db.ChiTietPhieuNhaps.Include(c => c.PhieuNhap).Include(c => c.Xe).Where(x => x.MaPhieuNhap == id).ToList();
                return View(chiTietPhieuNhaps);
            }
        }

        // GET: Admin/AdminChiTietPhieuNhap/Details/5
        public ActionResult Details(int id, int xe)
        {
            if (id == null || xe == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Where(x => x.MaPhieuNhap == id && x.MaXe == xe).FirstOrDefault();
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuNhap);
        }

        /*public ActionResult Details(int? id)
        {
            if (id == null || xe == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Where(x => x.MaPhieuNhap == id);
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuNhap);
        }*/

        // GET: Admin/AdminChiTietPhieuNhap/Create
        public ActionResult Create()
        {
            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap");
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe");
            return View();
        }

        // POST: Admin/AdminChiTietPhieuNhap/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create( ChiTietPhieuNhap chiTietPhieuNhap)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    /*db.ChiTietPhieuNhaps.Add(chiTietPhieuNhap);
                    db.SaveChanges();*/
                    
                    db.sp_ThemChiTietPhieuNhap(chiTietPhieuNhap.MaXe,chiTietPhieuNhap.MaPhieuNhap,chiTietPhieuNhap.SoLuongNhap,chiTietPhieuNhap.DonGiaNhap);
                    return RedirectToAction("Index");
                }
            }
            catch  (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }            

            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap", chiTietPhieuNhap.MaPhieuNhap);
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", chiTietPhieuNhap.MaXe);
            return View(chiTietPhieuNhap);
        }

        // GET: Admin/AdminChiTietPhieuNhap/Edit/5
        /*public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Find(id);
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap", chiTietPhieuNhap.MaPhieuNhap);
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", chiTietPhieuNhap.MaXe);
            return View(chiTietPhieuNhap);
        }
*/
        public ActionResult Edit(int? id,int? xe)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Where(x => x.MaPhieuNhap == id && x.MaXe == xe).FirstOrDefault();
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap", chiTietPhieuNhap.MaPhieuNhap);
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", chiTietPhieuNhap.MaXe);
            return View(chiTietPhieuNhap);
        }


        // POST: Admin/AdminChiTietPhieuNhap/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(ChiTietPhieuNhap chiTietPhieuNhap)
        {
            try
            {
                if (ModelState.IsValid)
                {
                    db.sp_CapNhatThongTinChiTietPhieuNhap(chiTietPhieuNhap.MaXe, chiTietPhieuNhap.MaPhieuNhap, chiTietPhieuNhap.SoLuongNhap, chiTietPhieuNhap.DonGiaNhap);                    
                    return RedirectToAction("Index");
                }
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ViewBag.MaPhieuNhap = new SelectList(db.PhieuNhaps, "MaPhieuNhap", "MaPhieuNhap", chiTietPhieuNhap.MaPhieuNhap);
            ViewBag.MaXe = new SelectList(db.Xes, "MaXe", "TenXe", chiTietPhieuNhap.MaXe);
            return View(chiTietPhieuNhap);
        }

        // GET: Admin/AdminChiTietPhieuNhap/Delete/5
        public ActionResult Delete(int? id, int? xe)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Where(x => x.MaPhieuNhap == id && x.MaXe == xe).FirstOrDefault();
            if (chiTietPhieuNhap == null)
            {
                return HttpNotFound();
            }
            return View(chiTietPhieuNhap);
        }

        // POST: Admin/AdminChiTietPhieuNhap/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id, int xe)
        {
            /*ChiTietPhieuNhap chiTietPhieuNhap = db.ChiTietPhieuNhaps.Where(x => x.MaPhieuNhap == id && x.MaXe == xe).FirstOrDefault();
            db.ChiTietPhieuNhaps.Remove(chiTietPhieuNhap);
            db.SaveChanges();
            return RedirectToAction("Index");*/
            try
            {
                db.sp_XoaThongTinChiTietPhieuNhap(id, xe);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewBag.ErrorInfo = ex.InnerException.Message;
            }
            ChiTietPhieuNhap phieunhap = db.ChiTietPhieuNhaps.Find(id);
            return View(phieunhap);
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
