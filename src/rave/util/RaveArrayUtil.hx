package rave.util;

class RaveArrayUtil
{
	/**
		Filters out all `null` values from an array.
	**/
	public static function filterNull(a:ReadonlyArray<Null<Any>>):Array<Any>
	{
		var arr:Array<Any> = [];
		for (v in a) if (null != v) arr.push(v);
		return arr;
	}

	/**
		Returns a new array containing only unique values from the input array.
		Input array does not need to be sorted.
		A predicate comparison function can be provided for comparing values.  Default
		comparison is ==.
	**/
	public static function distinct(array:ReadonlyArray<Any>, ?predicate:Any->Any->Bool):Array<Any>
	{
		var result = [];

		if (array.length <= 1) return array.toArray();

		if (null == predicate) predicate = Functions.equality;

		for (v in array)
		{
			var keep = !any(result, function(r)
			{
				return (predicate(r, v) : Bool);
			});
			if (keep) result.push(v);
		}

		return result;
	}
}
