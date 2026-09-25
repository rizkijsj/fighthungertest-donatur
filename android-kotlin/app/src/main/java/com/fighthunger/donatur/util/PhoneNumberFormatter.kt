package com.fighthunger.donatur.util
object PhoneNumberFormatter { fun format(value: String): String { val v=value.trim(); return when { v.startsWith("0") -> "+62${v.drop(1)}"; v.startsWith("8") -> "+62$v"; else -> v } } }
