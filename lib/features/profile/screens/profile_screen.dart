import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../models/profile_model.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ của tôi'),
        actions: [
          state.whenOrNull(
                data: (profile) => profile != null
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Chỉnh sửa',
                        onPressed: () => _showEditDialog(profile),
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Không tải được hồ sơ',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.read(profileProvider.notifier).load(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Không có dữ liệu'));
          }
          return _ProfileBody(profile: profile);
        },
      ),
    );
  }

  Future<void> _showEditDialog(ProfileModel profile) async {
    final nameCtrl = TextEditingController(text: profile.facebookName ?? '');
    final linkCtrl = TextEditingController(text: profile.facebookLink ?? '');
    final formKey = GlobalKey<FormState>();
    var isLoading = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false, // không cho đóng khi đang loading
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Cập nhật hồ sơ'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Tên Facebook',
                    hintText: 'Để trống để xoá',
                  ),
                  maxLength: 200,
                  validator: (v) {
                    if (v != null && v.length > 200)
                      return 'Facebook name tối đa 200 ký tự.';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: linkCtrl,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: 'Link Facebook',
                    hintText: 'Để trống để xoá',
                  ),
                  maxLength: 500,
                  validator: (v) {
                    if (v != null && v.length > 500)
                      return 'Facebook link tối đa 500 ký tự.';
                    return null;
                  },
                ),
                if (isLoading) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(ctx),
              child: const Text('Huỷ'),
            ),
            FilledButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      final name = nameCtrl.text.trim();
                      final link = linkCtrl.text.trim();

                      setDialogState(() => isLoading = true);

                      try {
                        await ref
                            .read(profileProvider.notifier)
                            .update(
                              facebookName: name.isEmpty ? null : name,
                              facebookLink: link.isEmpty ? null : link,
                            );
                        if (ctx.mounted)
                          Navigator.pop(ctx); // đóng sau khi xong
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cập nhật thành công'),
                            ),
                          );
                        }
                      } on DioException catch (e) {
                        setDialogState(() => isLoading = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(_extractErrorDetail(e))),
                          );
                        }
                      } catch (_) {
                        setDialogState(() => isLoading = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Cập nhật thất bại, vui lòng thử lại',
                              ),
                            ),
                          );
                        }
                      }
                    },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );

    nameCtrl.dispose();
    linkCtrl.dispose();
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
  }

  String _extractErrorDetail(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.isNotEmpty) return detail;
      final title = data['title'];
      if (title is String && title.isNotEmpty) return title;
    }
    final status = e.response?.statusCode;
    if (status == 401) return 'Phiên đăng nhập hết hạn, vui lòng đăng nhập lại';
    if (status == 404) return 'Không tìm thấy tài khoản';
    return 'Cập nhật thất bại (${status ?? 'lỗi mạng'})';
  }
}

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.profile});

  final ProfileModel profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatarUrl = profile.discordAvatarUrl;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: CircleAvatar(
            radius: 48,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person, size: 48)
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            profile.discordDisplayName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Discord ID: ${profile.discordId}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 8),
        _InfoTile(
          icon: Icons.facebook,
          label: 'Tên Facebook',
          value: profile.facebookName,
        ),
        _InfoTile(
          icon: Icons.link,
          label: 'Link Facebook',
          value: profile.facebookLink,
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red,
            side: const BorderSide(color: Colors.red),
            minimumSize: const Size.fromHeight(48),
          ),
          icon: const Icon(Icons.logout),
          label: const Text('Đăng xuất'),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Đăng xuất'),
                content: const Text('Bạn có chắc muốn đăng xuất không?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Huỷ'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Đăng xuất'),
                  ),
                ],
              ),
            );
            if (confirm == true) {
              await ref.read(authProvider.notifier).logout();
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value ?? 'Chưa có'),
      contentPadding: EdgeInsets.zero,
    );
  }
}
