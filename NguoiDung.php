<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Database\Eloquent\SoftDeletes;
use Laravel\Sanctum\HasApiTokens;

class NguoiDung extends Authenticatable
{
    use HasApiTokens, Notifiable, SoftDeletes;

    protected $table = 'nguoidung';
    protected $fillable = ['ten', 'email', 'matkhau', 'sodienthoai', 'diachi', 'avatar', 'vaitro', 'trangthai', 'reset_token', 'reset_token_expire'];
    protected $hidden = ['matkhau', 'reset_token'];

    public function getAuthPassword()
    {
        return $this->matkhau;
    }

    public function donHang() { return $this->hasMany(DonHang::class, 'nguoidung_id'); }
    public function gioHang() { return $this->hasOne(GioHang::class, 'nguoidung_id'); }
    public function baiViet() { return $this->hasMany(BaiViet::class, 'nguoidung_id'); }
    public function lienHe() { return $this->hasMany(LienHe::class, 'nguoidung_id'); }
}
