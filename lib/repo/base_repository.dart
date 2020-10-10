abstract class BaseRepository<K, T> {
  Future<K> create(T t);

  update(T t);

  Future<List<T>> getAll();

  Future<T> getById(K id);

  deleteById(K id);
}
